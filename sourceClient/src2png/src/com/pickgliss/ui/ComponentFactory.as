// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.ComponentFactory

package com.pickgliss.ui
{
    import flash.utils.Dictionary;
    import com.pickgliss.utils.ClassUtils;
    import flash.system.ApplicationDomain;
    import com.pickgliss.utils.StringUtils;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ObjectUtils;

    public final class ComponentFactory 
    {

        private static var _instance:ComponentFactory;
        private static var COMPONENT_COUNTER:int = 1;

        private var _allComponents:Dictionary;
        private var _model:ComponentModel;

        public function ComponentFactory(_arg_1:ComponentFactoryEnforcer)
        {
            this._model = new ComponentModel();
            this._allComponents = new Dictionary();
            ClassUtils.uiSourceDomain = ApplicationDomain.currentDomain;
        }

        public static function get Instance():ComponentFactory
        {
            if (_instance == null)
            {
                _instance = new ComponentFactory(new ComponentFactoryEnforcer());
            };
            return (_instance);
        }

        public static function parasArgs(_arg_1:String):Array
        {
            var _local_2:Array = _arg_1.split(",");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                StringUtils.trim(_local_2[_local_3]);
                _local_3++;
            };
            return (_local_2);
        }


        public function creat(_arg_1:String, _arg_2:Array=null):*
        {
            var _local_3:*;
            if (this._model.getComonentStyle(_arg_1))
            {
                _local_3 = this.creatComponentByStylename(_arg_1);
            }
            else
            {
                if (((this._model.getBitmapSet(_arg_1)) || (ClassUtils.classIsBitmapData(_arg_1))))
                {
                    _local_3 = this.creatBitmap(_arg_1);
                }
                else
                {
                    if (this._model.getCustomObjectStyle(_arg_1))
                    {
                        _local_3 = this.creatCustomObject(_arg_1, _arg_2);
                    }
                    else
                    {
                        _local_3 = ClassUtils.CreatInstance(_arg_1, _arg_2);
                    };
                };
            };
            if ((_local_3 is DisplayObject))
            {
                DisplayObject(_local_3).name = _arg_1;
            };
            return (_local_3);
        }

        public function creatBitmap(_arg_1:String):Bitmap
        {
            var _local_3:BitmapData;
            var _local_4:Bitmap;
            var _local_2:XML = this._model.getBitmapSet(_arg_1);
            if (_local_2 == null)
            {
                if (ClassUtils.uiSourceDomain.hasDefinition(_arg_1))
                {
                    _local_3 = ClassUtils.CreatInstance(_arg_1, [0, 0]);
                    _local_4 = new Bitmap(_local_3);
                    this._model.addBitmapSet(_arg_1, new XML((((((("<bitmapData resourceLink='" + _arg_1) + "' width='") + _local_4.width) + "' height='") + _local_4.height) + "' />")));
                }
                else
                {
                    throw (new Error((("Bitmap:" + _arg_1) + " is Not Found!"), 888));
                };
            }
            else
            {
                if (_local_2.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
                {
                    _local_3 = this.creatBitmapData(_arg_1);
                    _local_4 = new Bitmap(_local_3, "auto", (String(_local_2.@smoothing) == "true"));
                }
                else
                {
                    _local_4 = ClassUtils.CreatInstance(_arg_1);
                };
                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2);
            };
            return (_local_4);
        }

        public function creatBitmapData(_arg_1:String):BitmapData
        {
            var _local_3:BitmapData;
            var _local_2:XML = this._model.getBitmapSet(_arg_1);
            if (_local_2 == null)
            {
                return (ClassUtils.CreatInstance(_arg_1, [0, 0]));
            };
            if (_local_2.name() == ComponentSetting.BITMAPDATA_TAG_NAME)
            {
                _local_3 = ClassUtils.CreatInstance(_arg_1, [int(_local_2.@width), int(_local_2.@height)]);
            }
            else
            {
                _local_3 = ClassUtils.CreatInstance(_arg_1)["btimapData"];
            };
            return (_local_3);
        }

        public function creatComponentByStylename(_arg_1:String):*
        {
            var _local_2:XML = this.getComponentStyle(_arg_1);
            var _local_3:String = _local_2.@classname;
            var _local_4:* = ClassUtils.CreatInstance(_local_3);
            _local_4.id = this.componentID;
            this._allComponents[_local_4.id] = _local_4;
            if (ClassUtils.classIsComponent(_local_3))
            {
                _local_4.beginChanges();
                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2);
                _local_4.commitChanges();
            }
            else
            {
                ObjectUtils.copyPorpertiesByXML(_local_4, _local_2);
            };
            _local_4["stylename"] = _arg_1;
            return (_local_4);
        }

        private function getComponentStyle(_arg_1:String):XML
        {
            var _local_3:XML;
            var _local_2:XML = this._model.getComonentStyle(_arg_1);
            while (_local_2.hasOwnProperty("@parentStyle"))
            {
                _local_3 = this._model.getComonentStyle(String(_local_2.@parentStyle));
                delete _local_2.@parentStyle;
                ObjectUtils.combineXML(_local_2, _local_3);
            };
            return (_local_2);
        }

        public function getCustomStyle(_arg_1:String):XML
        {
            var _local_3:XML;
            var _local_2:XML = this._model.getCustomObjectStyle(_arg_1);
            if (_local_2 == null)
            {
                return (null);
            };
            while (((_local_2) && (_local_2.hasOwnProperty("@parentStyle"))))
            {
                _local_3 = this._model.getCustomObjectStyle(String(_local_2.@parentStyle));
                delete _local_2.@parentStyle;
                ObjectUtils.combineXML(_local_2, _local_3);
            };
            return (_local_2);
        }

        public function creatCustomObject(_arg_1:String, _arg_2:Array=null):*
        {
            var _local_3:XML = this.getCustomStyle(_arg_1);
            var _local_4:String = _local_3.@classname;
            var _local_5:* = ClassUtils.CreatInstance(_local_4, _arg_2);
            ObjectUtils.copyPorpertiesByXML(_local_5, _local_3);
            return (_local_5);
        }

        public function getComponentByID(_arg_1:int):*
        {
            return (this._allComponents[_arg_1]);
        }

        public function checkAllComponentDispose(_arg_1:Array):void
        {
            var _local_6:XML;
            var _local_7:*;
            var _local_2:Dictionary = this._model.allComponentStyle;
            var _local_3:int = _arg_1.length;
            var _local_4:int = 1;
            var _local_5:int;
            while (_local_5 < _arg_1.length)
            {
                for each (_local_6 in _local_2)
                {
                    if (((!(_local_6.@componentModule == null)) && (_local_6.@componentModule == _arg_1[_local_5])))
                    {
                        for each (_local_7 in this._allComponents)
                        {
                            if (((_local_7) && (_local_7.stylename == _local_6.@stylename)))
                            {
                                _local_4++;
                            };
                        };
                    };
                };
                _local_5++;
            };
        }

        public function removeComponent(_arg_1:int):void
        {
            delete this._allComponents[_arg_1];
        }

        public function creatFrameFilters(_arg_1:String):Array
        {
            var _local_2:Array = parasArgs(_arg_1);
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _local_2.length)
            {
                if (_local_2[_local_4] == "null")
                {
                    _local_3.push(null);
                }
                else
                {
                    _local_3.push(this.creatFilters(_local_2[_local_4]));
                };
                _local_4++;
            };
            return (_local_3);
        }

        public function creatFilters(_arg_1:String):Array
        {
            var _local_2:Array = _arg_1.split("|");
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _local_2.length)
            {
                _local_3.push(ComponentFactory.Instance.model.getSet(_local_2[_local_4]));
                _local_4++;
            };
            return (_local_3);
        }

        public function get model():ComponentModel
        {
            return (this._model);
        }

        public function setup(_arg_1:XML):void
        {
            this._model.addComponentSet(_arg_1);
        }

        public function get componentID():int
        {
            return (COMPONENT_COUNTER++);
        }


    }
}//package com.pickgliss.ui

class ComponentFactoryEnforcer 
{


}


