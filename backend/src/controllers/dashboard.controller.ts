import { Context } from 'hono';
import { drizzle } from 'drizzle-orm/d1';
import * as schema from '../db/schema';
import { DashboardRepository } from '../repositories/dashboard.repository';
import { DashboardService } from '../services/dashboard.service';

export const getSummary = async (c: Context) => {
  try {
    const db = drizzle(c.env.DB, { schema });
    const repo = new DashboardRepository(db);
    const service = new DashboardService(repo);
    
    // Optional query param
    const monthStr = c.req.query('month');
    
    const summary = await service.getDashboardSummary(monthStr);
    
    return c.json({
      success: true,
      data: summary
    });
  } catch (error) {
    console.error('Error fetching dashboard summary:', error);
    return c.json({ success: false, message: 'Internal Server Error' }, 500);
  }
};
