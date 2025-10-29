/* Firebase helpers (uses Hosting auto init via /__/firebase/init.js) */
function fb() {
  if (!window.firebase || !firebase.apps || !firebase.app) {
    throw new Error('Firebase SDK not loaded. Make sure scripts and /__/firebase/init.js are included.');
  }
  return firebase;
}

async function initAuthUI() {
  const auth = fb().auth();
  const db = fb().firestore();

  // Shared elements
  const signupForm = document.getElementById('signup-form');
  const signinForm = document.getElementById('signin-form');
  const phoneBtn = document.getElementById('send-otp');
  const verifyBtn = document.getElementById('verify-otp');
  const msg = document.getElementById('auth-msg');
  const roleSelectors = document.querySelectorAll('[data-role]');

  let currentRole = 'farmer';
  roleSelectors.forEach((el) => el.addEventListener('click', () => {
    currentRole = el.getAttribute('data-role');
    roleSelectors.forEach(b => b.classList.remove('active'));
    el.classList.add('active');
    const roleLabel = document.getElementById('roleLabel');
    if (roleLabel) roleLabel.textContent = currentRole.charAt(0).toUpperCase() + currentRole.slice(1);
  }));

  function toast(text, type = 'info') {
    if (!msg) return;
    msg.textContent = text;
    msg.style.color = type === 'error' ? '#b91c1c' : '#166534';
  }

  async function saveProfile(user, data) {
    await db.collection('users').doc(user.uid).set({
      uid: user.uid,
      role: currentRole,
      email: user.email || data.email || null,
      phone: data.phone || null,
      name: data.name || null,
      createdAt: fb().firestore.FieldValue.serverTimestamp(),
    }, { merge: true });
  }

  // Email + password signup
  if (signupForm) {
    signupForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const name = signupForm.name.value.trim();
      const email = signupForm.email.value.trim();
      const phone = signupForm.phone.value.trim();
      const password = signupForm.password.value;
      try {
        const { user } = await auth.createUserWithEmailAndPassword(email, password);
        await user.updateProfile({ displayName: name });
        await saveProfile(user, { name, phone, email });
        toast('Signup successful. You are logged in.');
        window.location.href = './index.html';
      } catch (err) {
        toast(err.message, 'error');
      }
    });
  }

  // Email + password sign in (role gated)
  if (signinForm) {
    signinForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      const email = signinForm.email.value.trim();
      const password = signinForm.password.value;
      try {
        const { user } = await auth.signInWithEmailAndPassword(email, password);
        // verify role matches
        const doc = await db.collection('users').doc(user.uid).get();
        const data = doc.exists ? doc.data() : null;
        if (data && data.role && data.role !== currentRole) {
          toast(`This account is registered as ${data.role}. Switch role.`, 'error');
          await auth.signOut();
          return;
        }
        toast('Logged in.');
        window.location.href = './index.html';
      } catch (err) {
        toast(err.message, 'error');
      }
    });
  }

  // Optional: phone verification flow (during signup)
  let confirmationResult = null;
  if (phoneBtn) {
    // Invisible recaptcha attached to button's container
    const recaptcha = new fb().auth.RecaptchaVerifier('recaptcha-container', { size: 'invisible' });
    phoneBtn.addEventListener('click', async () => {
      const phone = document.getElementById('signup-phone').value.trim();
      if (!phone) { toast('Enter phone with country code, e.g., +91...', 'error'); return; }
      try {
        confirmationResult = await auth.signInWithPhoneNumber(phone, recaptcha);
        toast('OTP sent to your phone');
      } catch (err) { toast(err.message, 'error'); }
    });
  }
  if (verifyBtn) {
    verifyBtn.addEventListener('click', async () => {
      const code = document.getElementById('otp').value.trim();
      if (!confirmationResult) { toast('Send OTP first', 'error'); return; }
      try {
        const credential = await confirmationResult.confirm(code);
        const phone = credential.user.phoneNumber;
        const user = fb().auth().currentUser;
        if (user) {
          await saveProfile(user, { phone });
          toast('Phone verified and saved');
        } else {
          toast('Phone verified. Please complete email signup.', 'info');
        }
      } catch (err) { toast(err.message, 'error'); }
    });
  }
}

// Auto-init on login page only
document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('login-page')) {
    // Wait until firebase auto init script runs
    const wait = setInterval(() => {
      if (window.firebase && firebase.app) {
        clearInterval(wait);
        initAuthUI().catch(console.error);
      }
    }, 50);
  }
});


