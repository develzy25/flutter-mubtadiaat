import React from 'react';
import { motion } from 'framer-motion';
import { DashboardHeader } from './components/DashboardHeader';
import { SummaryWidget } from './components/SummaryWidget';
import { TeachingScheduleWidget } from './components/TeachingScheduleWidget';
import { QuickActionWidget } from './components/QuickActionWidget';

export const MustahiqDashboard: React.FC = () => {
  const mockUser = {
    name: 'Charis Wahyudi',
    role: 'Mustahiq Bagian A (Lokal 01)',
  };
  return (
    <motion.div 
      initial={{ opacity: 0, y: 15 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, type: "spring", bounce: 0.3 }}
      className="pb-6 max-w-xl mx-auto"
    >
      {/* 1. Header & Greeting Card with 3D Calendar Widget */}
      <DashboardHeader name={mockUser.name} role={mockUser.role} />
      
      {/* 2. Ringkasan Hari Ini (4 3D Stat Cards) */}
      <SummaryWidget />
      
      {/* 3. Jadwal Mengajar Hari Ini (Timeline List from Blueprint) */}
      <TeachingScheduleWidget />

      {/* 4. Akses Cepat (4 3D Quick Buttons) */}
      <QuickActionWidget />
    </motion.div>
  );
};
