-- CreateEnum
CREATE TYPE "RuleCategory" AS ENUM ('VALIDATION', 'BUSINESS_LOGIC', 'COMPLIANCE', 'SECURITY', 'PRICING', 'WORKFLOW', 'NOTIFICATION');

-- CreateEnum
CREATE TYPE "EntityType" AS ENUM ('PATIENT', 'PROCEDURE', 'BILLING', 'MATERIAL', 'USER', 'SYSTEM');

-- CreateEnum
CREATE TYPE "ExecutionStatus" AS ENUM ('SUCCESS', 'FAILED', 'SKIPPED', 'TIMEOUT');

-- CreateEnum
CREATE TYPE "WorkflowCategory" AS ENUM ('PATIENT_ADMISSION', 'PROCEDURE_APPROVAL', 'BILLING_VALIDATION', 'AUDIT_PROCESS', 'COMPLIANCE_CHECK', 'CUSTOM');

-- CreateEnum
CREATE TYPE "InstanceStatus" AS ENUM ('ACTIVE', 'COMPLETED', 'TERMINATED', 'SUSPENDED', 'FAILED');

-- CreateEnum
CREATE TYPE "TaskType" AS ENUM ('USER_TASK', 'SERVICE_TASK', 'SCRIPT_TASK', 'BUSINESS_RULE_TASK', 'RECEIVE_TASK', 'MANUAL_TASK', 'SEND_TASK');

-- CreateEnum
CREATE TYPE "TaskStatus" AS ENUM ('CREATED', 'ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'FAILED');

-- CreateEnum
CREATE TYPE "TaskPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT', 'CRITICAL');

-- CreateEnum
CREATE TYPE "DecisionCategory" AS ENUM ('BUSINESS_RULE', 'VALIDATION', 'PRICING', 'RISK_ASSESSMENT', 'COMPLIANCE', 'ROUTING');

-- CreateEnum
CREATE TYPE "EvaluationStatus" AS ENUM ('SUCCESS', 'FAILED', 'ERROR');

-- CreateTable
CREATE TABLE "business_rules" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" "RuleCategory" NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0.0',
    "conditions" JSONB NOT NULL,
    "actions" JSONB NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "entityType" "EntityType" NOT NULL,
    "triggers" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "tags" TEXT[],

    CONSTRAINT "business_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_executions" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ruleId" TEXT NOT NULL,
    "entityType" "EntityType" NOT NULL,
    "entityId" TEXT NOT NULL,
    "entityData" JSONB NOT NULL,
    "status" "ExecutionStatus" NOT NULL,
    "result" JSONB,
    "error" TEXT,
    "duration" INTEGER,
    "actionsExecuted" JSONB,
    "userId" TEXT,
    "sessionId" TEXT,
    "metadata" JSONB,
    "patientId" TEXT,
    "procedureId" TEXT,
    "billingId" TEXT,

    CONSTRAINT "rule_executions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_definitions" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" "WorkflowCategory" NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0.0',
    "bpmnXml" TEXT NOT NULL,
    "diagram" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "tags" TEXT[],

    CONSTRAINT "workflow_definitions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_instances" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workflowId" TEXT NOT NULL,
    "instanceKey" TEXT NOT NULL,
    "status" "InstanceStatus" NOT NULL,
    "entityType" "EntityType" NOT NULL,
    "entityId" TEXT NOT NULL,
    "variables" JSONB NOT NULL,
    "startedBy" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" TIMESTAMP(3),
    "duration" INTEGER,
    "patientId" TEXT,
    "procedureId" TEXT,
    "billingId" TEXT,
    "metadata" JSONB,

    CONSTRAINT "workflow_instances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workflow_tasks" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "instanceId" TEXT NOT NULL,
    "taskKey" TEXT NOT NULL,
    "taskType" "TaskType" NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" "TaskStatus" NOT NULL,
    "priority" "TaskPriority" NOT NULL DEFAULT 'MEDIUM',
    "assignedTo" TEXT,
    "assignedAt" TIMESTAMP(3),
    "candidateGroups" TEXT[],
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "duration" INTEGER,
    "variables" JSONB,
    "formData" JSONB,
    "result" JSONB,
    "dueDate" TIMESTAMP(3),
    "followUpDate" TIMESTAMP(3),
    "metadata" JSONB,

    CONSTRAINT "workflow_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "decision_tables" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category" "DecisionCategory" NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0.0',
    "dmnXml" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "tags" TEXT[],

    CONSTRAINT "decision_tables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "decision_evaluations" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "decisionId" TEXT NOT NULL,
    "input" JSONB NOT NULL,
    "output" JSONB,
    "status" "EvaluationStatus" NOT NULL,
    "error" TEXT,
    "duration" INTEGER,
    "entityType" "EntityType",
    "entityId" TEXT,
    "userId" TEXT,
    "patientId" TEXT,
    "procedureId" TEXT,
    "billingId" TEXT,
    "metadata" JSONB,

    CONSTRAINT "decision_evaluations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "business_rules_name_key" ON "business_rules"("name");

-- CreateIndex
CREATE INDEX "business_rules_category_idx" ON "business_rules"("category");

-- CreateIndex
CREATE INDEX "business_rules_entityType_idx" ON "business_rules"("entityType");

-- CreateIndex
CREATE INDEX "business_rules_isActive_idx" ON "business_rules"("isActive");

-- CreateIndex
CREATE INDEX "business_rules_priority_idx" ON "business_rules"("priority");

-- CreateIndex
CREATE INDEX "rule_executions_ruleId_idx" ON "rule_executions"("ruleId");

-- CreateIndex
CREATE INDEX "rule_executions_entityType_entityId_idx" ON "rule_executions"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "rule_executions_status_idx" ON "rule_executions"("status");

-- CreateIndex
CREATE INDEX "rule_executions_createdAt_idx" ON "rule_executions"("createdAt");

-- CreateIndex
CREATE INDEX "rule_executions_patientId_idx" ON "rule_executions"("patientId");

-- CreateIndex
CREATE INDEX "rule_executions_procedureId_idx" ON "rule_executions"("procedureId");

-- CreateIndex
CREATE INDEX "rule_executions_billingId_idx" ON "rule_executions"("billingId");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_definitions_name_key" ON "workflow_definitions"("name");

-- CreateIndex
CREATE INDEX "workflow_definitions_category_idx" ON "workflow_definitions"("category");

-- CreateIndex
CREATE INDEX "workflow_definitions_isActive_idx" ON "workflow_definitions"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_instances_instanceKey_key" ON "workflow_instances"("instanceKey");

-- CreateIndex
CREATE INDEX "workflow_instances_workflowId_idx" ON "workflow_instances"("workflowId");

-- CreateIndex
CREATE INDEX "workflow_instances_instanceKey_idx" ON "workflow_instances"("instanceKey");

-- CreateIndex
CREATE INDEX "workflow_instances_status_idx" ON "workflow_instances"("status");

-- CreateIndex
CREATE INDEX "workflow_instances_entityType_entityId_idx" ON "workflow_instances"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "workflow_instances_startedAt_idx" ON "workflow_instances"("startedAt");

-- CreateIndex
CREATE INDEX "workflow_instances_patientId_idx" ON "workflow_instances"("patientId");

-- CreateIndex
CREATE INDEX "workflow_instances_procedureId_idx" ON "workflow_instances"("procedureId");

-- CreateIndex
CREATE INDEX "workflow_instances_billingId_idx" ON "workflow_instances"("billingId");

-- CreateIndex
CREATE UNIQUE INDEX "workflow_tasks_taskKey_key" ON "workflow_tasks"("taskKey");

-- CreateIndex
CREATE INDEX "workflow_tasks_instanceId_idx" ON "workflow_tasks"("instanceId");

-- CreateIndex
CREATE INDEX "workflow_tasks_taskKey_idx" ON "workflow_tasks"("taskKey");

-- CreateIndex
CREATE INDEX "workflow_tasks_status_idx" ON "workflow_tasks"("status");

-- CreateIndex
CREATE INDEX "workflow_tasks_assignedTo_idx" ON "workflow_tasks"("assignedTo");

-- CreateIndex
CREATE INDEX "workflow_tasks_dueDate_idx" ON "workflow_tasks"("dueDate");

-- CreateIndex
CREATE UNIQUE INDEX "decision_tables_name_key" ON "decision_tables"("name");

-- CreateIndex
CREATE INDEX "decision_tables_category_idx" ON "decision_tables"("category");

-- CreateIndex
CREATE INDEX "decision_tables_isActive_idx" ON "decision_tables"("isActive");

-- CreateIndex
CREATE INDEX "decision_evaluations_decisionId_idx" ON "decision_evaluations"("decisionId");

-- CreateIndex
CREATE INDEX "decision_evaluations_status_idx" ON "decision_evaluations"("status");

-- CreateIndex
CREATE INDEX "decision_evaluations_entityType_entityId_idx" ON "decision_evaluations"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "decision_evaluations_createdAt_idx" ON "decision_evaluations"("createdAt");

-- CreateIndex
CREATE INDEX "decision_evaluations_patientId_idx" ON "decision_evaluations"("patientId");

-- CreateIndex
CREATE INDEX "decision_evaluations_procedureId_idx" ON "decision_evaluations"("procedureId");

-- CreateIndex
CREATE INDEX "decision_evaluations_billingId_idx" ON "decision_evaluations"("billingId");

-- AddForeignKey
ALTER TABLE "rule_executions" ADD CONSTRAINT "rule_executions_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "business_rules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_instances" ADD CONSTRAINT "workflow_instances_workflowId_fkey" FOREIGN KEY ("workflowId") REFERENCES "workflow_definitions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workflow_tasks" ADD CONSTRAINT "workflow_tasks_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "workflow_instances"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decision_evaluations" ADD CONSTRAINT "decision_evaluations_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decision_tables"("id") ON DELETE CASCADE ON UPDATE CASCADE;
