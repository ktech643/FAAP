/**
 * FAAP Scan App - Validation Utilities
 * Common validation functions for forms and user input
 */

/**
 * Validate email address
 */
export const validateEmail = (email: string): string | undefined => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  
  if (!email) return 'Email is required';
  if (!emailRegex.test(email)) return 'Please enter a valid email address';
  
  return undefined;
};

/**
 * Validate password strength
 */
export const validatePassword = (password: string): string | undefined => {
  if (!password) return 'Password is required';
  if (password.length < 8) return 'Password must be at least 8 characters';
  if (!/(?=.*[a-z])/.test(password)) return 'Password must contain at least one lowercase letter';
  if (!/(?=.*[A-Z])/.test(password)) return 'Password must contain at least one uppercase letter';
  if (!/(?=.*\d)/.test(password)) return 'Password must contain at least one number';
  
  return undefined;
};

/**
 * Validate required field
 */
export const validateRequired = (value: string, fieldName: string): string | undefined => {
  if (!value || value.trim() === '') {
    return `${fieldName} is required`;
  }
  return undefined;
};

/**
 * Validate name (letters, spaces, hyphens only)
 */
export const validateName = (name: string): string | undefined => {
  if (!name) return 'Name is required';
  if (name.length < 2) return 'Name must be at least 2 characters';
  if (!/^[a-zA-Z\s\-']+$/.test(name)) return 'Name can only contain letters, spaces, hyphens, and apostrophes';
  
  return undefined;
};

/**
 * Validate phone number
 */
export const validatePhone = (phone: string): string | undefined => {
  const phoneRegex = /^\+?[\d\s\-\(\)]+$/;
  
  if (!phone) return 'Phone number is required';
  if (!phoneRegex.test(phone)) return 'Please enter a valid phone number';
  if (phone.replace(/\D/g, '').length < 10) return 'Phone number must be at least 10 digits';
  
  return undefined;
};

/**
 * Validate barcode format
 */
export const validateBarcode = (barcode: string): string | undefined => {
  if (!barcode) return 'Barcode is required';
  if (!/^\d{8,14}$/.test(barcode)) return 'Barcode must be 8-14 digits';
  
  return undefined;
};

/**
 * Validate age (must be a number between 1 and 120)
 */
export const validateAge = (age: string): string | undefined => {
  const ageNum = parseInt(age, 10);
  
  if (!age) return 'Age is required';
  if (isNaN(ageNum)) return 'Age must be a number';
  if (ageNum < 1 || ageNum > 120) return 'Age must be between 1 and 120';
  
  return undefined;
};

/**
 * Validate weight (must be a positive number)
 */
export const validateWeight = (weight: string): string | undefined => {
  const weightNum = parseFloat(weight);
  
  if (!weight) return 'Weight is required';
  if (isNaN(weightNum)) return 'Weight must be a number';
  if (weightNum <= 0) return 'Weight must be a positive number';
  if (weightNum > 1000) return 'Weight seems unrealistic';
  
  return undefined;
};

/**
 * Validate height (must be a positive number)
 */
export const validateHeight = (height: string): string | undefined => {
  const heightNum = parseFloat(height);
  
  if (!height) return 'Height is required';
  if (isNaN(heightNum)) return 'Height must be a number';
  if (heightNum <= 0) return 'Height must be a positive number';
  if (heightNum > 300) return 'Height seems unrealistic';
  
  return undefined;
};

/**
 * Validate URL format
 */
export const validateUrl = (url: string): string | undefined => {
  const urlRegex = /^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$/;
  
  if (!url) return undefined; // URL is optional
  if (!urlRegex.test(url)) return 'Please enter a valid URL';
  
  return undefined;
};

/**
 * Validate that passwords match
 */
export const validatePasswordConfirmation = (password: string, confirmation: string): string | undefined => {
  if (!confirmation) return 'Please confirm your password';
  if (password !== confirmation) return 'Passwords do not match';
  
  return undefined;
};

/**
 * Generic validator function type
 */
export type ValidatorFunction = (value: string) => string | undefined;

/**
 * Combine multiple validators
 */
export const combineValidators = (...validators: ValidatorFunction[]): ValidatorFunction => {
  return (value: string) => {
    for (const validator of validators) {
      const error = validator(value);
      if (error) return error;
    }
    return undefined;
  };
};