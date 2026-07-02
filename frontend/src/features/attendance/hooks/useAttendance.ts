import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getAttendance, saveAttendance } from '../services/attendance.service';

export const useAttendance = (classId: string, month: string) => {
  return useQuery({
    queryKey: ['attendance', classId, month],
    queryFn: () => getAttendance(classId, month),
    enabled: !!classId && !!month
  });
};

export const useSaveAttendance = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: saveAttendance,
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['attendance', variables.classId, variables.month] });
      // Optionally invalidate dashboard summary to reflect new edits immediately
      queryClient.invalidateQueries({ queryKey: ['dashboardSummary', variables.month] });
    }
  });
};
