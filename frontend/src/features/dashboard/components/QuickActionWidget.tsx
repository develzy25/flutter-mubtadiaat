import React from 'react';
import { useNavigate } from 'react-router';
import { 
  Users, 
  CheckSquare, 
  Award, 
  Calendar, 
  FileSpreadsheet, 
  FileText, 
  ShieldCheck, 
  ClipboardList 
} from 'lucide-react';
import { GlassCard } from '../../../components/ui/GlassCard';

export const QuickActionWidget: React.FC = () => {
  const navigate = useNavigate();

  // Structured professionally into Harian & Akademik (exactly 8 actions in 4-4 grid split)
  const actions = [
    // --- Baris 1: Operasional Harian & Kehadiran ---
    {
      title: 'Absensi',
      icon: CheckSquare,
      color: 'bg-purple-500/10 text-purple-600',
      path: '/absensi',
    },
    {
      title: 'Tamrin',
      icon: FileText,
      color: 'bg-indigo-500/10 text-indigo-600',
      path: '/tamrin',
    },
    {
      title: 'Setoran',
      icon: Award,
      color: 'bg-amber-500/10 text-amber-600',
      path: '/hafalan',
    },
    {
      title: 'Jadwal',
      icon: Calendar,
      color: 'bg-emerald-500/10 text-emerald-600',
      path: '/jadwal',
    },
    // --- Baris 2: Penilaian Akademik & Laporan ---
    {
      title: 'Input Nilai',
      icon: FileSpreadsheet,
      color: 'bg-rose-500/10 text-rose-600',
      path: '/nilai',
    },
    {
      title: 'E-Raport',
      icon: Users,
      color: 'bg-blue-500/10 text-blue-600',
      path: '/raport',
    },
    {
      title: 'Sertifikat',
      icon: ShieldCheck,
      color: 'bg-teal-500/10 text-teal-600',
      path: '/sertifikat',
    },
    {
      title: 'Rekap Nilai',
      icon: ClipboardList,
      color: 'bg-indigo-500/10 text-indigo-600',
      path: '/rekap-nilai',
    },
  ];

  return (
    <div className="flex flex-col gap-3 my-6">
      <h3 className="text-sm font-extrabold text-slate-500 uppercase tracking-wider px-1">Akses Cepat</h3>

      <div className="grid grid-cols-4 gap-3">
        {actions.map((act, idx) => {
          const Icon = act.icon;
          return (
            <GlassCard
              key={idx}
              variant="neumorph"
              hoverEffect
              className="p-3.5 flex flex-col items-center justify-center text-center cursor-pointer min-h-24 transition-all duration-300"
              onClick={() => navigate(act.path)}
            >
              <div className={`w-10 h-10 rounded-2xl ${act.color} flex items-center justify-center mb-2 neumorph-pressed`}>
                <Icon className="w-5 h-5" />
              </div>
              <span className="text-[10px] font-bold text-slate-700 leading-tight">{act.title}</span>
            </GlassCard>
          );
        })}
      </div>
    </div>
  );
};
