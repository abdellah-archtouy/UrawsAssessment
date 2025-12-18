const { body, param } = require('express-validator');

exports.validateUser = [
  body('firstname')
    .trim()
    .notEmpty().withMessage('First name is required')
    .isLength({ min: 2, max: 100 }).withMessage('First name must be between 2 and 100 characters'),
  
  body('lastname')
    .trim()
    .notEmpty().withMessage('Last name is required')
    .isLength({ min: 2, max: 100 }).withMessage('Last name must be between 2 and 100 characters'),
  
  body('email')
    .trim()
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Must be a valid email address')
    .normalizeEmail()
];

exports.validateUserId = [
  param('id')
    .isInt({ min: 1 }).withMessage('User ID must be a positive integer')
];
