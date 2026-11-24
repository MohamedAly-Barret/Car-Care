-- CreateTable
CREATE TABLE "organizations" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "branches" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "organizations_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    CONSTRAINT "branches_organizations_id_fkey" FOREIGN KEY ("organizations_id") REFERENCES "organizations" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "staff" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "branch_id" TEXT NOT NULL,
    "organizations_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "staff_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "staff_organizations_id_fkey" FOREIGN KEY ("organizations_id") REFERENCES "organizations" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "customers" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "branch_id" TEXT NOT NULL,
    "organizations_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "temp_login_code" TEXT,
    "code_expires_at" DATETIME,
    CONSTRAINT "customers_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "customers_organizations_id_fkey" FOREIGN KEY ("organizations_id") REFERENCES "organizations" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "cars" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "customer_id" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "plate_number" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    CONSTRAINT "cars_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "work_orders" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "branch_id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "car_id" TEXT NOT NULL,
    "customer_complaint" TEXT NOT NULL,
    "tracking_code" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'Pending',
    CONSTRAINT "work_orders_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "work_orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "work_orders_car_id_fkey" FOREIGN KEY ("car_id") REFERENCES "cars" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "work_order_details" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "work_order_id" TEXT NOT NULL,
    "technician_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "labor_cost" REAL NOT NULL,
    "approval_status" TEXT NOT NULL DEFAULT 'Pending',
    CONSTRAINT "work_order_details_work_order_id_fkey" FOREIGN KEY ("work_order_id") REFERENCES "work_orders" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "work_order_details_technician_id_fkey" FOREIGN KEY ("technician_id") REFERENCES "staff" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "crm_interactions" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "customer_id" TEXT NOT NULL,
    "work_order_id" TEXT NOT NULL,
    "scheduled_data" DATETIME NOT NULL,
    "type" TEXT NOT NULL,
    "id_closed" BOOLEAN NOT NULL DEFAULT false,
    "satisafaction_rating" INTEGER,
    "result_notes" TEXT,
    CONSTRAINT "crm_interactions_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "crm_interactions_work_order_id_fkey" FOREIGN KEY ("work_order_id") REFERENCES "work_orders" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "work_order_id" TEXT NOT NULL,
    "serial_number" TEXT NOT NULL,
    "subtotal" REAL NOT NULL,
    "discount" REAL NOT NULL DEFAULT 0,
    "tax" REAL NOT NULL DEFAULT 0,
    "total" REAL NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT "invoices_work_order_id_fkey" FOREIGN KEY ("work_order_id") REFERENCES "work_orders" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
);

-- CreateTable
CREATE TABLE "invoice_details" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "invoices_id" TEXT NOT NULL,
    "work_order_id" TEXT NOT NULL,
    "accountant_id" TEXT NOT NULL,
    "issued_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "grand_total" REAL NOT NULL,
    "notes" TEXT,
    CONSTRAINT "invoice_details_invoices_id_fkey" FOREIGN KEY ("invoices_id") REFERENCES "invoices" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "invoice_details_accountant_id_fkey" FOREIGN KEY ("accountant_id") REFERENCES "staff" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- CreateIndex
CREATE UNIQUE INDEX "staff_email_key" ON "staff"("email");

-- CreateIndex
CREATE UNIQUE INDEX "customers_phone_key" ON "customers"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "cars_plate_number_key" ON "cars"("plate_number");

-- CreateIndex
CREATE UNIQUE INDEX "work_orders_tracking_code_key" ON "work_orders"("tracking_code");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_serial_number_key" ON "invoices"("serial_number");
