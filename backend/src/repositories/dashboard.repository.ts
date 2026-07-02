import { sql } from 'drizzle-orm';
import { drizzle } from 'drizzle-orm/d1';
import * as schema from '../db/schema';

export class DashboardRepository {
  constructor(private db: ReturnType<typeof drizzle<typeof schema>>) {}

  async getAttendanceSummary(monthStr: string) {
    // monthStr format: YYYY-MM
    // Using sum directly on the integer columns
    const result = await this.db.select({
      total: sql<number>`count(*)`,
      hadir: sql<number>`sum(${schema.attendanceDetails.hadir})`,
      sakit: sql<number>`sum(${schema.attendanceDetails.sakit})`,
      izin: sql<number>`sum(${schema.attendanceDetails.izin})`,
      alpha: sql<number>`sum(${schema.attendanceDetails.alpha})`
    })
    .from(schema.attendanceDetails)
    .innerJoin(schema.attendance, sql`${schema.attendanceDetails.attendanceId} = ${schema.attendance.id}`)
    .where(sql`${schema.attendance.month} = ${monthStr}`);

    return result[0];
  }

  async getTotalSantri() {
    const result = await this.db.select({ count: sql<number>`count(*)` })
      .from(schema.santriRefs)
      .where(sql`is_active = true`);
      
    return result[0]?.count || 0;
  }
}
