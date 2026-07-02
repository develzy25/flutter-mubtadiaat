import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Calendar, Clock, MapPin, BookOpen } from 'lucide-react';
import { GlassCard } from '../../components/ui/GlassCard';
import { LIRBOYO_SCHEDULE_SEED } from '../../mocks/schedule.seed';

export const JadwalPage: React.FC = () => {
  const daysList = ['Sabtu', 'Ahad', 'Senin', 'Selasa', 'Rabu', 'Kamis'];
  const [activeDay, setActiveDay] = useState<string>('Sabtu');

  // Filter schedule for the active day and lock to the Mustahiq's class (Bagian A)
  const dailySchedule = LIRBOYO_SCHEDULE_SEED.filter(
    (s) => s.day === activeDay && s.bagianClass === 'Bagian A'
  );

  return (
    <motion.div
      initial={{ opacity: 0, y: 15 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, type: "spring", bounce: 0.3 }}
      className="pb-6 max-w-xl mx-auto"
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <div className="w-12 h-12 rounded-2xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center neumorph-pressed shrink-0">
          <Calendar className="w-6 h-6" />
        </div>
        <div>
          <h1 className="text-xl font-extrabold text-slate-800 tracking-tight">Jadwal Mengajar</h1>
          <p className="text-xs text-slate-500 font-medium">Jadwal Harian Kwartal I MPHM Lirboyo</p>
        </div>
      </div>

      {/* Horizontal Day Selector Tabs */}
      <div className="flex gap-2 overflow-x-auto pb-2 mb-6 scrollbar-none">
        {daysList.map((day) => (
          <button
            key={day}
            type="button"
            onClick={() => setActiveDay(day)}
            className={`px-5 py-2.5 rounded-2xl text-xs font-bold shrink-0 transition-all duration-300 ${
              activeDay === day
                ? 'neumorph-pressed text-emerald-600 border border-emerald-200'
                : 'neumorph text-slate-500 hover:text-slate-700'
            }`}
          >
            {day}
          </button>
        ))}
      </div>

      {/* Daily Schedule Timeline */}
      <div className="flex flex-col gap-4">
        <span className="text-xs font-extrabold text-slate-500 uppercase tracking-wider px-1">
          Agenda Hari {activeDay}
        </span>

        {dailySchedule.length > 0 ? (
          dailySchedule.map((item) => (
            <GlassCard key={item.id} variant="neumorph" className="p-4 border-l-4 border-l-emerald-500">
              <div className="flex items-start justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center shrink-0">
                    <BookOpen className="w-5 h-5" />
                  </div>
                  <div className="flex flex-col min-w-0">
                    <h3 className="text-base font-bold text-slate-800 truncate">{item.subjectName}</h3>
                    <span className="text-xs text-slate-400 font-semibold">{item.subjectCategory}</span>
                  </div>
                </div>

                <span className="text-[10px] font-extrabold px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700 shrink-0">
                  Hishah {item.session}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-2 mt-4 pt-3 border-t border-slate-200/60 text-xs text-slate-500 font-medium">
                <span className="flex items-center gap-1.5">
                  <Clock className="w-4 h-4 text-emerald-600" />
                  {item.session === 1 ? '07:30 - 08:30' : '09:00 - 10:00'}
                </span>
                <span className="flex items-center gap-1.5">
                  <MapPin className="w-4 h-4 text-emerald-600" />
                  {item.bagianClass} ({item.lokalRoom})
                </span>
              </div>

              <div className="mt-3 text-xs font-bold text-slate-700 bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                Ustadz/ah: {item.teacherName}
              </div>
            </GlassCard>
          ))
        ) : (
          <div className="p-8 text-center text-slate-400 text-sm font-semibold neumorph rounded-2xl">
            Tidak ada jadwal mengajar pada hari {activeDay}.
          </div>
        )}
      </div>
    </motion.div>
  );
};
