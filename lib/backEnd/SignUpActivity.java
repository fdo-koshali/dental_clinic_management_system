public class SignUpActivity extends AppCompatActivity {
    EditText emailEditText, usernameEditText, mobileEditText, passwordEditText;
    Button signUpButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        // Initialize EditText and Button
        emailEditText = findViewById(R.id.emailEditText);
        usernameEditText = findViewById(R.id.usernameEditText);
        mobileEditText = findViewById(R.id.mobileEditText);
        passwordEditText = findViewById(R.id.passwordEditText);
        signUpButton = findViewById(R.id.signUpButton);

        // Set up the sign-up button click listener
        signUpButton.setOnClickListener(v -> {
            String email = emailEditText.getText().toString().trim();
            String username = usernameEditText.getText().toString().trim();
            String mobile = mobileEditText.getText().toString().trim();
            String password = passwordEditText.getText().toString().trim();

            if (email.isEmpty() || username.isEmpty() || mobile.isEmpty() || password.isEmpty()) {
                // Show error: All fields must be filled
                return;
            }

            // Call the sign-up method
            signUpUser(email, username, mobile, password);
        });
    }

    public void signUpUser(String email, String username, String mobile, String password) {
        FirebaseAuth auth = FirebaseAuth.getInstance();
        FirebaseFirestore db = FirebaseFirestore.getInstance();

        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener(task -> {
                if (task.isSuccessful()) {
                    FirebaseUser firebaseUser = auth.getCurrentUser();
                    if (firebaseUser != null) {
                        String userId = firebaseUser.getUid();  // Get unique user ID

                        // Create user data map to store in Firestore
                        Map<String, Object> user = new HashMap<>();
                        user.put("email", email);
                        user.put("username", username);
                        user.put("mobile", mobile);
                        user.put("password", password); // Be careful with password storage (use hashing in real apps)
                        user.put("confirmedPassword", password); // Ensure passwords match

                        // Store data in Firestore 'users' collection
                        db.collection("users").document(userId).set(user)
                            .addOnSuccessListener(aVoid -> {
                                Log.d("Firestore", "User added successfully");
                            })
                            .addOnFailureListener(e -> {
                                Log.e("Firestore", "Error adding user", e);
                            });
                    }
                } else {
                    Log.e("Signup", "Error creating user", task.getException());
                }
            });
    }
}
