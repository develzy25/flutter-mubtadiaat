import { DashboardRepository } from '../repositories/dashboard.repository';

export class DashboardService {
  constructor(private dashboardRepo: DashboardRepository) {}

  async getDashboardSummary(monthStr?: string) {
    // default to current month if not provided
    const currentMonth = monthStr || new Date().toISOString().slice(0, 7); // Gets YYYY-MM
    
    const [attendanceSummary, totalSantri] = await Promise.all([
      this.dashboardRepo.getAttendanceSummary(currentMonth),
      this.dashboardRepo.getTotalSantri()
    ]);

    return {
      month: currentMonth,
      totalSantri,
      attendance: {
        hadir: Number(attendanceSummary.hadir || 0),
        sakit: Number(attendanceSummary.sakit || 0),
        izin: Number(attendanceSummary.izin || 0),
        alpha: Number(attendanceSummary.alpha || 0),
      }
    };
  }
}
