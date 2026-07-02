import { BrowserRouter, Routes, Route, Navigate } from 'react-router';
import { QueryClientProvider } from '@tanstack/react-query';
import { queryClient } from './cache/queryClient';
import { ErrorBoundary } from './components/ErrorBoundary';
import { ProtectedRoute } from './components/ProtectedRoute';
import { DashboardLayout } from './layouts/DashboardLayout';
import { MustahiqDashboard } from './features/dashboard/MustahiqDashboard';
import { AttendancePage } from './features/attendance/AttendancePage';
import { KelasPage } from './features/kelas/KelasPage';
import { MemorizationPage } from './features/memorization/MemorizationPage';
import { ProfilPage } from './features/profile/ProfilPage';
import { JadwalPage } from './features/schedule/JadwalPage';
import { InputNilaiPage } from './features/grades/InputNilaiPage';
import { RekapNilaiPage } from './features/grades/RekapNilaiPage';
import { ERaportPage } from './features/grades/ERaportPage';
import { SertifikatPage } from './features/sertifikat/SertifikatPage';
import { TamrinPage } from './features/tamrin/TamrinPage';
import { LoginPage } from './features/auth/LoginPage';

function App() {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>
          <Routes>
            <Route path="/" element={<Navigate to="/login" replace />} />
            <Route path="/login" element={<LoginPage />} />
            
            <Route element={<ProtectedRoute />}>
              <Route element={<DashboardLayout />}>
                <Route path="/dashboard" element={<MustahiqDashboard />} />
                <Route path="/kelas" element={<KelasPage />} />
                <Route path="/hafalan" element={<MemorizationPage />} />
                <Route path="/profil" element={<ProfilPage />} />
                <Route path="/jadwal" element={<JadwalPage />} />
                <Route path="/nilai" element={<InputNilaiPage />} />
                <Route path="/rekap-nilai" element={<RekapNilaiPage />} />
                <Route path="/raport" element={<ERaportPage />} />
                <Route path="/sertifikat" element={<SertifikatPage />} />
                <Route path="/tamrin" element={<TamrinPage />} />
                <Route path="/absensi" element={<AttendancePage />} />
                <Route path="*" element={<Navigate to="/dashboard" replace />} />
              </Route>
            </Route>
          </Routes>
        </BrowserRouter>
      </QueryClientProvider>
    </ErrorBoundary>
  );
}

export default App;
