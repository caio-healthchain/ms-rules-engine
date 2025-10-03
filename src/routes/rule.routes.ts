import { Router } from 'express';
import { RuleController } from '@/controllers/rule.controller';
import { asyncHandler } from '@/middleware/error-handler';

const router = Router();
const controller = new RuleController();

/**
 * @swagger
 * tags:
 *   name: Rules
 *   description: Operações relacionadas a rules
 */

// CRUD routes (sem auth para demonstração)
router.get('/', asyncHandler(controller.list.bind(controller)));
router.get('/:id', asyncHandler(controller.getById.bind(controller)));
router.post('/', asyncHandler(controller.create.bind(controller)));
router.put('/:id', asyncHandler(controller.update.bind(controller)));
router.delete('/:id', asyncHandler(controller.delete.bind(controller)));

export default router;
