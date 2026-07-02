import { Hono } from 'hono';
import { getSummary } from '../controllers/dashboard.controller';

const dashboardRoutes = new Hono();

dashboardRoutes.get('/summary', getSummary);

export { dashboardRoutes };
