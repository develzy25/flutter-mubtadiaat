import React from 'react';
import { motion } from 'framer-motion';

interface DashboardHeaderProps {
  name: string;
  role?: string;
  unreadNotifications?: number;
}

export const DashboardHeader: React.FC<DashboardHeaderProps> = ({ name }) => {
  const todayDate = new Date();
  const dayName = todayDate.toLocaleDateString('id-ID', { weekday: 'long' });
  const dayNum = todayDate.getDate();
  const monthYear = todayDate.toLocaleDateString('id-ID', { month: 'short', year: 'numeric' });

  return (
    <div className="flex flex-col gap-4 mb-6">
      {/* Top Brand Title */}
      <div className="flex flex-col">
        <span className="text-xs font-semibold uppercase tracking-wider text-slate-400">Pondok Pesantren</span>
        <h1 className="text-xl sm:text-2xl font-extrabold text-slate-800 tracking-tight">
          Hidayatul Mubtadi'at Lirboyo
        </h1>
        <p className="text-xs sm:text-sm font-medium text-slate-500">Aplikasi Pengajar</p>
      </div>

      {/* Greeting Card with Neumorphic 3D styling & 3D Calendar Widget */}
      <motion.div 
        initial={{ opacity: 0, y: 15 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4, type: "spring", bounce: 0.3 }}
        className="neumorph rounded-3xl p-4 sm:p-5 flex items-center justify-between gap-3 relative overflow-hidden"
      >
        {/* Left Side: Avatar & Greeting */}
        <div className="flex items-center gap-3 sm:gap-4 flex-1 min-w-0">
          <div className="w-14 h-14 sm:w-16 sm:h-16 rounded-full neumorph flex items-center justify-center shrink-0 p-1 relative">
            <div className="w-full h-full rounded-full overflow-hidden bg-blue-100 flex items-center justify-center">
              <span className="text-xl font-bold text-blue-700">
                {name.charAt(0)}
              </span>
            </div>
          </div>

          <div className="flex flex-col min-w-0">
            <span className="text-xs font-medium text-slate-400">Assalamu'alaikum,</span>
            <h2 className="text-base sm:text-lg font-bold text-slate-800 truncate">{name}</h2>
            <p className="text-xs text-slate-500 line-clamp-2 mt-0.5">
              Semoga hari ini penuh keberkahan dalam mengajar dan membimbing.
            </p>
          </div>
        </div>

        {/* Right Side: 3D Calendar Widget */}
        <div className="neumorph rounded-2xl overflow-hidden w-20 sm:w-24 shrink-0 flex flex-col items-center border border-white/50 shadow-sm">
          <div className="w-full bg-linear-to-r from-blue-600 to-blue-500 py-1 text-center">
            <span className="text-[11px] font-bold text-white uppercase tracking-wider">{dayName}</span>
          </div>
          <div className="p-2 flex flex-col items-center justify-center bg-[#F0F4F8]">
            <span className="text-2xl sm:text-3xl font-extrabold text-slate-800 leading-none">{dayNum}</span>
            <span className="text-[10px] font-semibold text-slate-400 mt-0.5">{monthYear}</span>
          </div>
        </div>
      </motion.div>
    </div>
  );
};
