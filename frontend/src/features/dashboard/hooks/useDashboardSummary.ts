import { useQuery } from '@tanstack/react-query';
import { getDashboardSummary } from '../services/dashboard.service';

export const useDashboardSummary = (month?: string) => {
  return useQuery({
    queryKey: ['dashboardSummary', month],
    queryFn: () => getDashboardSummary(month),
  });
};
