class SkiiveValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 4) {
      return 'Password must be at least 6 characters long.';
    }

    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter.';
    // }

    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number.';
    // }

    // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format';
    }

    return null;
  }

  static String? validateMpesaNumber(String? value) {
    // Check if the value is null or empty
    if (value == null || value.isEmpty) {
      return 'Please enter your number';
    }

    // Trim leading and trailing whitespace
    value = value.trim();

    // Check if the number starts with '254' and has the correct length
    if (!value.startsWith('254') || value.length != 12) {
      return 'Number must start with 254 and have 12 digits';
    }

    // Check if the remaining part of the string is numeric
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid number';
    }

    return null; // Return null if the validation passes
  }
}
