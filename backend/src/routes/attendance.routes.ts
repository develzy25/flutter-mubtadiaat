import { Hono } from 'hono';
import { getAttendance, saveAttendance } from '../controllers/attendance.controller';

const attendanceRoutes = new Hono();

attendanceRoutes.get('/', getAttendance);
attendanceRoutes.post('/', saveAttendance);

export { attendanceRoutes };
