// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.FSM__UTF8_wcrtomb

package cmodule.decry
{
    import avm2.intrinsics.memory.*; // ASC2.0, AIR3.6 SDK and above, FlasCC (Alchemy)

    public final class FSM__UTF8_wcrtomb extends Machine 
    {


        public static function start():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            mstate.esp = (mstate.esp - 4);
            si32(mstate.ebp, mstate.esp);
            mstate.ebp = mstate.esp;
            mstate.esp = (mstate.esp - 0);
            _local_1 = li32(mstate.ebp + 16);
            _local_2 = li32(mstate.ebp + 8);
            _local_1 = li32(_local_1 + 4);
            _local_3 = li32(mstate.ebp + 12);
            _local_4 = _local_2;
            if (!(_local_1 == 0))
            {
                _local_2 = 22;
                si32(_local_2, _val_2E_939);
                _local_2 = -1;
                mstate.eax = _local_2;
            }
            else
            {
                if (!(_local_2 == 0))
                {
                    if (!(uint(_local_3) > uint(127)))
                    {
                        _local_4 = 1;
                        si8(_local_3, _local_2);
                        mstate.eax = _local_4;
                        goto _label_3;
                    };
                    if (!(uint(_local_3) > uint(2047)))
                    {
                        _local_1 = 2;
                        _local_5 = 192;
                    }
                    else
                    {
                        if (!(uint(_local_3) > uint(0xFFFF)))
                        {
                            _local_1 = 3;
                            _local_5 = 224;
                        }
                        else
                        {
                            if (!(uint(_local_3) > uint(2097151)))
                            {
                                _local_1 = 4;
                                _local_5 = 240;
                            }
                            else
                            {
                                if (!(uint(_local_3) > uint(0x3FFFFFF)))
                                {
                                    _local_1 = 5;
                                    _local_5 = 248;
                                }
                                else
                                {
                                    if (_local_3 < 0) goto _label_4;
                                    _local_1 = 6;
                                    _local_5 = 252;
                                };
                            };
                        };
                    };
                    _local_6 = _local_3;
                    _local_7 = (_local_1 + -1);
                    if (!(_local_7 > 0))
                    {
                        _local_3 = _local_6;
                    }
                    else
                    {
                        _local_7 = (_local_1 + -1);
                        
                    _label_1: 
                        _local_6 = (_local_6 | 0xFFFFFF80);
                        _local_6 = (_local_6 & 0xFFFFFFBF);
                        _local_8 = (_local_4 + _local_7);
                        si8(_local_6, _local_8);
                        _local_6 = (_local_3 >> 6);
                        _local_3 = (_local_7 + -1);
                        _local_8 = _local_6;
                        if (_local_3 > 0) goto _label_5;
                        _local_3 = _local_6;
                    };
                    _local_3 = (_local_3 | _local_5);
                    si8(_local_3, _local_2);
                }
                else
                {
                    _local_1 = 1;
                };
                
            _label_2: 
                mstate.eax = _local_1;
            };
            
        _label_3: 
            mstate.esp = mstate.ebp;
            mstate.ebp = li32(mstate.esp);
            mstate.esp = (mstate.esp + 4);
            mstate.esp = (mstate.esp + 4);
            return;
            
        _label_4: 
            _local_1 = 86;
            si32(_local_1, _val_2E_939);
            _local_1 = -1;
            goto _label_2;
            
        _label_5: 
            _local_7 = _local_3;
            _local_3 = _local_8;
            goto _label_1;
        }


    }
}//package cmodule.decry

