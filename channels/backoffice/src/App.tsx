import type { ReactNode } from 'react';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { AuthProvider } from '@/auth/AuthProvider';
import { useAuth } from '@/auth/AuthContext';
import BoLayout from '@/components/BoLayout';
import ClientDetailPage from '@/pages/ClientDetailPage';
import ClientListPage from '@/pages/ClientListPage';
import LoanOpsPage from '@/pages/LoanOpsPage';
import LoginPage from '@/pages/LoginPage';

function RequireAuth({ children }: { children: ReactNode }) {
  const { session } = useAuth();
  if (!session) {
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route
            path="/"
            element={
              <RequireAuth>
                <BoLayout />
              </RequireAuth>
            }
          >
            <Route index element={<Navigate to="/clients" replace />} />
            <Route path="clients" element={<ClientListPage />} />
            <Route path="clients/:clientId" element={<ClientDetailPage />} />
            <Route path="loan-ops" element={<LoanOpsPage />} />
          </Route>
          <Route path="*" element={<Navigate to="/clients" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
