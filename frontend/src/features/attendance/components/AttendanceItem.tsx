import { useState, useEffect } from 'react';
import { GlassCard } from '../../../components/ui/GlassCard';
import { SoftInput } from '../../../components/ui/SoftInput';

interface AttendanceItemProps {
  santri: {
    santriId: string;
    nis: string;
    name: string;
    hadir: number;
    sakit: number;
    izin: number;
    alpha: number;
  };
  onChange: (santriId: string, field: 'hadir' | 'sakit' | 'izin' | 'alpha', value: number) => void;
}

export const AttendanceItem = ({ santri, onChange }: AttendanceItemProps) => {
  // Local state for smooth UI typing
  const [values, setValues] = useState({
    hadir: santri.hadir,
    sakit: santri.sakit,
    izin: santri.izin,
    alpha: santri.alpha
  });

  useEffect(() => {
    setValues({
      hadir: santri.hadir,
      sakit: santri.sakit,
      izin: santri.izin,
      alpha: santri.alpha
    });
  }, [santri]);

  const handleChange = (field: 'hadir' | 'sakit' | 'izin' | 'alpha', val: string) => {
    let numVal = parseInt(val, 10);
    if (isNaN(numVal) || numVal < 0) numVal = 0;
    if (numVal > 31) numVal = 31; // Max days in a month
    
    setValues(prev => ({ ...prev, [field]: numVal }));
    onChange(santri.santriId, field, numVal);
  };

  return (
    <GlassCard variant="neumorph" className="mb-4">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex-1">
          <p className="text-xs text-blue-600 font-bold mb-1">{santri.nis}</p>
          <h4 className="text-base font-bold text-slate-800">{santri.name}</h4>
        </div>
        
        <div className="grid grid-cols-4 gap-2 md:w-[60%] lg:w-[50%]">
          <div>
            <label className="text-[10px] uppercase font-bold text-slate-500 mb-1 block">Hadir</label>
            <SoftInput 
              type="number"
              min={0}
              max={31}
              value={values.hadir.toString()} 
              onChange={(e) => handleChange('hadir', e.target.value)}
              className="text-center h-10 px-2"
            />
          </div>
          <div>
            <label className="text-[10px] uppercase font-bold text-slate-500 mb-1 block">Sakit</label>
            <SoftInput 
              type="number"
              min={0}
              max={31}
              value={values.sakit.toString()} 
              onChange={(e) => handleChange('sakit', e.target.value)}
              className="text-center h-10 px-2"
            />
          </div>
          <div>
            <label className="text-[10px] uppercase font-bold text-slate-500 mb-1 block">Izin</label>
            <SoftInput 
              type="number"
              min={0}
              max={31}
              value={values.izin.toString()} 
              onChange={(e) => handleChange('izin', e.target.value)}
              className="text-center h-10 px-2"
            />
          </div>
          <div>
            <label className="text-[10px] uppercase font-bold text-slate-500 mb-1 block">Alpha</label>
            <SoftInput 
              type="number"
              min={0}
              max={31}
              value={values.alpha.toString()} 
              onChange={(e) => handleChange('alpha', e.target.value)}
              className="text-center h-10 px-2"
            />
          </div>
        </div>
      </div>
    </GlassCard>
  );
};
