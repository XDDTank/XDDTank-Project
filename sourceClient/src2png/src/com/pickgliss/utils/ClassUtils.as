// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.ClassUtils

package com.pickgliss.utils
{
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;
    import flash.errors.IllegalOperationError;
    import flash.utils.getQualifiedSuperclassName;

    public final class ClassUtils 
    {

        public static const INNERRECTANGLE:String = "com.pickgliss.geom.InnerRectangle";
        public static const OUTTERRECPOS:String = "com.pickgliss.geom.OuterRectPos";
        public static const RECTANGLE:String = "flash.geom.Rectangle";
        public static const COLOR_MATIX_FILTER:String = "flash.filters.ColorMatrixFilter";
        private static var _appDomain:ApplicationDomain;


        public static function CreatInstance(_arg_1:String, _arg_2:Array=null):*
        {
            var _local_4:Object;
            var _local_3:Object = getDefinitionByName(_arg_1);
            if (_local_3 == null)
            {
                throw (new IllegalOperationError((("can't find the class of\"" + _arg_1) + '"in current domain')));
            };
            if (((_arg_2 == null) || (_arg_2.length == 0)))
            {
                _local_4 = new (_local_3)();
            }
            else
            {
                if (_arg_2.length == 1)
                {
                    _local_4 = new _local_3(_arg_2[0]);
                }
                else
                {
                    if (_arg_2.length == 2)
                    {
                        _local_4 = new _local_3(_arg_2[0], _arg_2[1]);
                    }
                    else
                    {
                        if (_arg_2.length == 3)
                        {
                            _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2]);
                        }
                        else
                        {
                            if (_arg_2.length == 4)
                            {
                                _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3]);
                            }
                            else
                            {
                                if (_arg_2.length == 5)
                                {
                                    _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4]);
                                }
                                else
                                {
                                    if (_arg_2.length == 6)
                                    {
                                        _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5]);
                                    }
                                    else
                                    {
                                        if (_arg_2.length == 7)
                                        {
                                            _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6]);
                                        }
                                        else
                                        {
                                            if (_arg_2.length == 8)
                                            {
                                                _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7]);
                                            }
                                            else
                                            {
                                                if (_arg_2.length == 9)
                                                {
                                                    _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7], _arg_2[8]);
                                                }
                                                else
                                                {
                                                    if (_arg_2.length == 10)
                                                    {
                                                        _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7], _arg_2[8], _arg_2[9]);
                                                    }
                                                    else
                                                    {
                                                        if (_arg_2.length == 11)
                                                        {
                                                            _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7], _arg_2[8], _arg_2[9], _arg_2[10]);
                                                        }
                                                        else
                                                        {
                                                            if (_arg_2.length == 12)
                                                            {
                                                                _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7], _arg_2[8], _arg_2[9], _arg_2[10], _arg_2[11]);
                                                            }
                                                            else
                                                            {
                                                                if (_arg_2.length == 13)
                                                                {
                                                                    _local_4 = new _local_3(_arg_2[0], _arg_2[1], _arg_2[2], _arg_2[3], _arg_2[4], _arg_2[5], _arg_2[6], _arg_2[7], _arg_2[8], _arg_2[9], _arg_2[10], _arg_2[11], _arg_2[12]);
                                                                }
                                                                else
                                                                {
                                                                    throw (new IllegalOperationError("arguments too long"));
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_4);
        }

        public static function get uiSourceDomain():ApplicationDomain
        {
            return (_appDomain);
        }

        public static function set uiSourceDomain(_arg_1:ApplicationDomain):void
        {
            _appDomain = _arg_1;
        }

        public static function getDefinition(_arg_1:String):Object
        {
            return (getDefinitionByName(_arg_1));
        }

        public static function classIsBitmapData(_arg_1:String):Boolean
        {
            if ((!(_appDomain.hasDefinition(_arg_1))))
            {
                return (false);
            };
            var _local_2:* = getDefinitionByName(_arg_1);
            var _local_3:String = getQualifiedSuperclassName(_local_2);
            return (_local_3 == "flash.display::BitmapData");
        }

        public static function classIsComponent(_arg_1:String):Boolean
        {
            if ((((((_arg_1 == "com.pickgliss.ui.text.FilterFrameText") || (_arg_1 == "com.pickgliss.ui.controls.SimpleDropListTarget")) || (_arg_1 == "ddt.view.FriendDropListTarget")) || (_arg_1 == "com.pickgliss.ui.text.FilterFrameTextWithTips")) || (_arg_1 == "eliteGame.view.EliteGamePaarungText")))
            {
                return (false);
            };
            return (true);
        }


    }
}//package com.pickgliss.utils

