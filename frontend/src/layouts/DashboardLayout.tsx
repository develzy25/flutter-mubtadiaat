
import { Outlet } from 'react-router';
import { BottomNavigation } from '../components/ui/BottomNavigation';

export const DashboardLayout = () => {
  return (
    <div className="min-h-dvh bg-[#F0F4F8] relative pb-28">
      {/* Main Content Area */}
      <main className="container max-w-xl mx-auto px-4 py-6">
        <Outlet />
      </main>

      {/* Persistent Bottom Navigation for Mobile First approach */}
      <BottomNavigation />
    </div>
  );
};
