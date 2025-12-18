const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { validateUser, validateUserId } = require('../middleware/validators');


router.get('/', userController.getAllUsers);

router.get('/:id', validateUserId, userController.getUserById);

router.post('/', validateUser, userController.createUser);

router.put('/:id', validateUserId, validateUser, userController.updateUser);

router.delete('/:id', validateUserId, userController.deleteUser);

module.exports = router;
