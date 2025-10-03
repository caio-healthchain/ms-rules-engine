import { Request, Response } from 'express';
import { BaseController } from './base.controller';
import { ApiResponse, PaginatedResponse } from '@/types';

/**
 * @swagger
 * components:
 *   schemas:
 *     Rule:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: ID único do rule
 *         name:
 *           type: string
 *           description: Nome do rule
 *         status:
 *           type: string
 *           enum: [active, inactive, pending]
 *           description: Status do rule
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data de atualização
 *       required:
 *         - id
 *         - name
 *         - status
 *     CreateRuleRequest:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Nome do rule
 *         status:
 *           type: string
 *           enum: [active, inactive, pending]
 *           description: Status inicial
 *       required:
 *         - name
 *     UpdateRuleRequest:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Nome do rule
 *         status:
 *           type: string
 *           enum: [active, inactive, pending]
 *           description: Status do rule
 */

export class RuleController extends BaseController {
  
  /**
   * @swagger
   * /api/v1/rules:
   *   get:
   *     summary: Listar rules
   *     description: Retorna uma lista paginada de rules
   *     tags:
   *       - Rules
   *     parameters:
   *       - in: query
   *         name: page
   *         schema:
   *           type: integer
   *           minimum: 1
   *           default: 1
   *         description: Número da página
   *       - in: query
   *         name: limit
   *         schema:
   *           type: integer
   *           minimum: 1
   *           maximum: 100
   *           default: 20
   *         description: Itens por página
   *       - in: query
   *         name: search
   *         schema:
   *           type: string
   *         description: Termo de busca
   *       - in: query
   *         name: status
   *         schema:
   *           type: string
   *           enum: [active, inactive, pending]
   *         description: Filtrar por status
   *     responses:
   *       200:
   *         description: Lista de rules recuperada com sucesso
   *         content:
   *           application/json:
   *             schema:
   *               allOf:
   *                 - $ref: '#/components/schemas/ApiResponse'
   *                 - type: object
   *                   properties:
   *                     data:
   *                       $ref: '#/components/schemas/PaginatedResponse'
   *       400:
   *         $ref: '#/components/responses/BadRequest'
   *       401:
   *         $ref: '#/components/responses/Unauthorized'
   *       500:
   *         $ref: '#/components/responses/InternalServerError'
   */
  async list(req: Request, res: Response): Promise<void> {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;
      const search = req.query.search as string;
      const status = req.query.status as string;

      // Simular dados para demonstração
      const mockData = Array.from({ length: limit }, (_, i) => ({
        id: `rule-${(page - 1) * limit + i + 1}`,
        name: `Rule ${(page - 1) * limit + i + 1}`,
        status: ['active', 'inactive', 'pending'][i % 3],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      }));

      const response: ApiResponse<PaginatedResponse<any>> = {
        success: true,
        message: 'Rules retrieved successfully',
        data: {
          items: mockData,
          pagination: {
            page,
            limit,
            total: 100,
            totalPages: Math.ceil(100 / limit),
            hasNext: page < Math.ceil(100 / limit),
            hasPrev: page > 1,
          },
        },
        timestamp: new Date().toISOString(),
      };

      res.json(response);
    } catch (error) {
      this.sendError(res, 'Failed to retrieve rules', 500);
    }
  }

  /**
   * @swagger
   * /api/v1/rules/{id}:
   *   get:
   *     summary: Obter rule por ID
   *     description: Retorna um rule específico pelo ID
   *     tags:
   *       - Rules
   *     parameters:
   *       - in: path
   *         name: id
   *         required: true
   *         schema:
   *           type: string
   *         description: ID do rule
   *     responses:
   *       200:
   *         description: Rule recuperado com sucesso
   *         content:
   *           application/json:
   *             schema:
   *               allOf:
   *                 - $ref: '#/components/schemas/ApiResponse'
   *                 - type: object
   *                   properties:
   *                     data:
   *                       $ref: '#/components/schemas/Rule'
   *       404:
   *         $ref: '#/components/responses/NotFound'
   *       500:
   *         $ref: '#/components/responses/InternalServerError'
   */
  async getById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;

      // Simular busca por ID
      const mockData = {
        id,
        name: `Rule ${id}`,
        status: 'active',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      this.sendResponse(res, mockData, 'Rule retrieved successfully');
    } catch (error) {
      this.sendError(res, 'Rule not found', 404);
    }
  }

  /**
   * @swagger
   * /api/v1/rules:
   *   post:
   *     summary: Criar novo rule
   *     description: Cria um novo rule
   *     tags:
   *       - Rules
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             $ref: '#/components/schemas/CreateRuleRequest'
   *     responses:
   *       201:
   *         description: Rule criado com sucesso
   *         content:
   *           application/json:
   *             schema:
   *               allOf:
   *                 - $ref: '#/components/schemas/ApiResponse'
   *                 - type: object
   *                   properties:
   *                     data:
   *                       $ref: '#/components/schemas/Rule'
   *       400:
   *         $ref: '#/components/responses/BadRequest'
   *       401:
   *         $ref: '#/components/responses/Unauthorized'
   *       500:
   *         $ref: '#/components/responses/InternalServerError'
   */
  async create(req: Request, res: Response): Promise<void> {
    try {
      const { name, status } = req.body;

      // Simular criação
      const mockData = {
        id: `rule-${Date.now()}`,
        name,
        status: status || 'pending',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      res.status(201);
      this.sendResponse(res, mockData, 'Rule created successfully');
    } catch (error) {
      this.sendError(res, 'Failed to create rule', 500);
    }
  }

  /**
   * @swagger
   * /api/v1/rules/{id}:
   *   put:
   *     summary: Atualizar rule
   *     description: Atualiza um rule existente
   *     tags:
   *       - Rules
   *     parameters:
   *       - in: path
   *         name: id
   *         required: true
   *         schema:
   *           type: string
   *         description: ID do rule
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             $ref: '#/components/schemas/UpdateRuleRequest'
   *     responses:
   *       200:
   *         description: Rule atualizado com sucesso
   *         content:
   *           application/json:
   *             schema:
   *               allOf:
   *                 - $ref: '#/components/schemas/ApiResponse'
   *                 - type: object
   *                   properties:
   *                     data:
   *                       $ref: '#/components/schemas/Rule'
   *       404:
   *         $ref: '#/components/responses/NotFound'
   *       400:
   *         $ref: '#/components/responses/BadRequest'
   *       500:
   *         $ref: '#/components/responses/InternalServerError'
   */
  async update(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { name, status } = req.body;

      // Simular atualização
      const mockData = {
        id,
        name: name || `Rule ${id}`,
        status: status || 'active',
        createdAt: new Date(Date.now() - 86400000).toISOString(), // 1 day ago
        updatedAt: new Date().toISOString(),
      };

      this.sendResponse(res, mockData, 'Rule updated successfully');
    } catch (error) {
      this.sendError(res, 'Failed to update rule', 500);
    }
  }

  /**
   * @swagger
   * /api/v1/rules/{id}:
   *   delete:
   *     summary: Excluir rule
   *     description: Exclui um rule existente
   *     tags:
   *       - Rules
   *     parameters:
   *       - in: path
   *         name: id
   *         required: true
   *         schema:
   *           type: string
   *         description: ID do rule
   *     responses:
   *       200:
   *         description: Rule excluído com sucesso
   *         content:
   *           application/json:
   *             schema:
   *               $ref: '#/components/schemas/ApiResponse'
   *       404:
   *         $ref: '#/components/responses/NotFound'
   *       500:
   *         $ref: '#/components/responses/InternalServerError'
   */
  async delete(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;

      // Simular exclusão
      this.sendResponse(res, null, 'Rule deleted successfully');
    } catch (error) {
      this.sendError(res, 'Failed to delete rule', 500);
    }
  }
}
