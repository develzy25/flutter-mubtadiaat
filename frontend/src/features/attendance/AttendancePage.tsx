import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Save, Calendar, CheckCircle2, AlertCircle } from 'lucide-react';
import { useAttendance, useSaveAttendance } from './hooks/useAttendance';
import type { AttendanceDetail } from './services/attendance.service';
import { AttendanceItem } from './components/AttendanceItem';
import { PremiumButton } from '../../components/ui/PremiumButton';
import { GlassCard } from '../../components/ui/GlassCard';

export const AttendancePage = () => {
  // In a real app, this comes from auth context/session. 
  // We use dummy values as created in seed.sql
  const MOCK_CLASS_ID = 'kelas-001'; 
  const MOCK_USER_ID = 'user-dummy-mustahiq';
  
  // Default to current month YYYY-MM
  const [selectedMonth, setSelectedMonth] = useState(new Date().toISOString().slice(0, 7));
  const [localDetails, setLocalDetails] = useState<AttendanceDetail[]>([]);
  
  const { data, isLoading, isError, refetch } = useAttendance(MOCK_CLASS_ID, selectedMonth);
  const saveMutation = useSaveAttendance();

  // Sync server data to local state for editing
  useEffect(() => {
    if (data?.data?.details) {
      setLocalDetails(data.data.details);
    }
  }, [data]);

  const handleItemChange = (santriId: string, field: keyof AttendanceDetail, value: number) => {
    setLocalDetails(prev => 
      prev.map(item => 
        item.santriId === santriId 
          ? { ...item, [field]: value } 
          : item
      )
    );
  };

  const handleSave = () => {
    saveMutation.mutate({
      classId: MOCK_CLASS_ID,
      month: selectedMonth,
      recordedBy: MOCK_USER_ID,
      details: localDetails
    });
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      className="pb-24 pt-4 px-4 max-w-3xl mx-auto"
    >
      <div className="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4">
        <div>
          <h1 className="text-2xl font-extrabold text-slate-800 tracking-tight">Rekap Absensi</h1>
          <p className="text-slate-500 font-medium mt-1">Isi rekap kehadiran bulanan santri</p>
        </div>
        
        <GlassCard variant="neumorph" className="py-2 px-4 flex items-center gap-3">
          <Calendar className="w-5 h-5 text-blue-600" />
          <input 
            type="month" 
            value={selectedMonth}
            onChange={(e) => setSelectedMonth(e.target.value)}
            className="bg-transparent border-none outline-hidden font-bold text-slate-700 cursor-pointer"
          />
        </GlassCard>
      </div>

      {isLoading ? (
        <div className="flex flex-col items-center justify-center py-20 gap-3">
          <div className="w-10 h-10 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin" />
          <p className="text-slate-500 font-medium animate-pulse">Memuat data santri...</p>
        </div>
      ) : isError ? (
        <div className="bg-red-50 p-6 rounded-2xl flex flex-col items-center justify-center border border-red-100 text-center">
          <AlertCircle className="w-10 h-10 text-red-500 mb-2" />
          <h3 className="text-red-700 font-bold">Gagal Memuat Data</h3>
          <p className="text-red-600 text-sm mt-1">Periksa koneksi Anda atau coba lagi nanti.</p>
          <PremiumButton onClick={() => refetch()} variant="secondary" className="mt-4">
            Coba Lagi
          </PremiumButton>
        </div>
      ) : (
        <div className="space-y-2">
          {saveMutation.isSuccess && (
            <motion.div 
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: 'auto' }}
              className="bg-green-50 p-4 rounded-xl border border-green-200 flex items-center gap-3 mb-4 text-green-700 font-medium"
            >
              <CheckCircle2 className="w-5 h-5" />
              Data rekap bulan {selectedMonth} berhasil disimpan!
            </motion.div>
          )}

          {localDetails.map(santri => (
            <AttendanceItem 
              key={santri.santriId} 
              santri={santri} 
              onChange={handleItemChange} 
            />
          ))}

          {localDetails.length === 0 && (
            <div className="text-center py-12 text-slate-500">
              Tidak ada data santri di kelas ini.
            </div>
          )}

          {localDetails.length > 0 && (
            <div className="fixed bottom-20 md:bottom-6 left-0 right-0 px-4 md:px-0 md:static mt-8 z-40 max-w-3xl mx-auto">
              <PremiumButton
                onClick={handleSave}
                isLoading={saveMutation.isPending}
                className="w-full h-14 text-lg shadow-floating"
                rightIcon={<Save className="w-5 h-5" />}
              >
                Simpan Rekap Bulanan
              </PremiumButton>
            </div>
          )}
        </div>
      )}
    </motion.div>
  );
};
