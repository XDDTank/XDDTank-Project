// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.ObjectUtils

package com.pickgliss.utils
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.getQualifiedClassName;
    import flash.utils.describeType;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    public final class ObjectUtils 
    {

        private static var _copyAbleTypes:Vector.<String>;
        private static var _descriptOjbXMLs:Dictionary;


        public static function cloneSimpleObject(_arg_1:Object):Object
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            return (_local_2.readObject());
        }

        public static function copyPorpertiesByXML(object:Object, data:XML):void
        {
            var item:XML;
            var propname:String;
            var value:String;
            var attr:XMLList = data.attributes();
            for each (item in attr)
            {
                propname = item.name().toString();
                if (object.hasOwnProperty(propname))
                {
                    try
                    {
                        value = item.toString();
                        if (value == "false")
                        {
                            object[propname] = false;
                        }
                        else
                        {
                            object[propname] = value;
                        };
                    }
                    catch(e:Error)
                    {
                    };
                };
            };
        }

        public static function copyProperties(_arg_1:Object, _arg_2:Object):void
        {
            var _local_4:XMLList;
            var _local_6:XML;
            var _local_7:XML;
            var _local_8:String;
            var _local_9:String;
            var _local_10:String;
            var _local_11:String;
            if (_descriptOjbXMLs == null)
            {
                _descriptOjbXMLs = new Dictionary();
            };
            var _local_3:Vector.<String> = getCopyAbleType();
            var _local_5:XML = describeTypeSave(_arg_2);
            _local_4 = _local_5.variable;
            for each (_local_6 in _local_4)
            {
                _local_8 = _local_6.@type;
                if (_local_3.indexOf(_local_8) != -1)
                {
                    _local_9 = _local_6.@name;
                    if (_arg_1.hasOwnProperty(_local_9))
                    {
                        _arg_1[_local_9] = _arg_2[_local_9];
                    };
                };
            };
            _local_4 = _local_5.accessor;
            for each (_local_7 in _local_4)
            {
                _local_10 = _local_7.@type;
                if (_local_3.indexOf(_local_10) != -1)
                {
                    _local_11 = _local_7.@name;
                    try
                    {
                        _arg_1[_local_11] = _arg_2[_local_11];
                    }
                    catch(err:Error)
                    {
                    };
                };
            };
        }

        public static function disposeAllChildren(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:DisplayObject;
            if (_arg_1 == null)
            {
                return;
            };
            while (_arg_1.numChildren > 0)
            {
                _local_2 = _arg_1.getChildAt(0);
                ObjectUtils.disposeObject(_local_2);
            };
        }

        public static function removeChildAllChildren(_arg_1:DisplayObjectContainer):void
        {
            while (_arg_1.numChildren > 0)
            {
                _arg_1.removeChildAt(0);
            };
        }

        public static function disposeObject(_arg_1:Object):void
        {
            var _local_2:DisplayObject;
            var _local_3:Bitmap;
            var _local_4:BitmapData;
            var _local_5:MovieClip;
            var _local_6:DisplayObject;
            if (_arg_1 == null)
            {
                return;
            };
            if ((_arg_1 is Disposeable))
            {
                if ((_arg_1 is DisplayObject))
                {
                    _local_2 = (_arg_1 as DisplayObject);
                    if (_local_2.parent)
                    {
                        _local_2.parent.removeChild(_local_2);
                    };
                };
                Disposeable(_arg_1).dispose();
            }
            else
            {
                if ((_arg_1 is Bitmap))
                {
                    _local_3 = Bitmap(_arg_1);
                    if (_local_3.parent)
                    {
                        _local_3.parent.removeChild(_local_3);
                    };
                    _local_3.bitmapData.dispose();
                }
                else
                {
                    if ((_arg_1 is BitmapData))
                    {
                        _local_4 = BitmapData(_arg_1);
                        _local_4.dispose();
                    }
                    else
                    {
                        if ((_arg_1 is MovieClip))
                        {
                            _local_5 = MovieClip(_arg_1);
                            _local_5.stop();
                            if (_local_5.parent)
                            {
                                _local_5.parent.removeChild(_local_5);
                            };
                        }
                        else
                        {
                            if ((_arg_1 is DisplayObject))
                            {
                                _local_6 = DisplayObject(_arg_1);
                                if (_local_6.parent)
                                {
                                    _local_6.parent.removeChild(_local_6);
                                };
                            };
                        };
                    };
                };
            };
        }

        private static function getCopyAbleType():Vector.<String>
        {
            if (_copyAbleTypes == null)
            {
                _copyAbleTypes = new Vector.<String>();
                _copyAbleTypes.push("int");
                _copyAbleTypes.push("uint");
                _copyAbleTypes.push("String");
                _copyAbleTypes.push("Boolean");
                _copyAbleTypes.push("Number");
            };
            return (_copyAbleTypes);
        }

        public static function describeTypeSave(_arg_1:Object):XML
        {
            var _local_2:XML;
            var _local_3:String = getQualifiedClassName(_arg_1);
            if (_descriptOjbXMLs[_local_3] != null)
            {
                _local_2 = _descriptOjbXMLs[_local_3];
            }
            else
            {
                _local_2 = describeType(_arg_1);
                _descriptOjbXMLs[_local_3] = _local_2;
            };
            return (_local_2);
        }

        public static function encode(node:String, object:Object):XML
        {
            var value:Object;
            var key:String;
            var v:XML;
            var temp:String = (("<" + node) + " ");
            var classInfo:XML = describeTypeSave(object);
            if (classInfo.@name.toString() == "Object")
            {
                for (key in object)
                {
                    value = object[key];
                    if ((!(value is Function)))
                    {
                        temp = (temp + encodingProperty(key, value));
                    };
                };
            }
            else
            {
                for each (v in classInfo..*.((name() == "variable") || (name() == "accessor")))
                {
                    temp = (temp + encodingProperty(v.@name.toString(), object[v.@name]));
                };
            };
            temp = (temp + "/>");
            return (new XML(temp));
        }

        private static function encodingProperty(_arg_1:String, _arg_2:Object):String
        {
            if ((_arg_2 is Array))
            {
                return ("");
            };
            return (((escapeString(_arg_1) + '="') + String(_arg_2)) + '" ');
        }

        private static function escapeString(_arg_1:String):String
        {
            var _local_3:String;
            var _local_6:String;
            var _local_7:String;
            var _local_2:String = "";
            var _local_4:Number = _arg_1.length;
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_3 = _arg_1.charAt(_local_5);
                switch (_local_3)
                {
                    case '"':
                        _local_2 = (_local_2 + '\\"');
                        break;
                    case "/":
                        _local_2 = (_local_2 + "\\/");
                        break;
                    case "\\":
                        _local_2 = (_local_2 + "\\\\");
                        break;
                    case "\b":
                        _local_2 = (_local_2 + "\\b");
                        break;
                    case "\f":
                        _local_2 = (_local_2 + "\\f");
                        break;
                    case "\n":
                        _local_2 = (_local_2 + "\\n");
                        break;
                    case "\r":
                        _local_2 = (_local_2 + "\\r");
                        break;
                    case "\t":
                        _local_2 = (_local_2 + "\\t");
                        break;
                    default:
                        if (_local_3 < " ")
                        {
                            _local_6 = _local_3.charCodeAt(0).toString(16);
                            _local_7 = ((_local_6.length == 2) ? "00" : "000");
                            _local_2 = (_local_2 + (("\\u" + _local_7) + _local_6));
                        }
                        else
                        {
                            _local_2 = (_local_2 + _local_3);
                        };
                };
                _local_5++;
            };
            return (_local_2);
        }

        public static function modifyVisibility(_arg_1:Boolean, ... _args):void
        {
            var _local_3:int;
            while (_local_3 < _args.length)
            {
                (_args[_local_3] as DisplayObject).visible = _arg_1;
                _local_3++;
            };
        }

        public static function copyPropertyByRectangle(_arg_1:DisplayObject, _arg_2:Rectangle):void
        {
            _arg_1.x = _arg_2.x;
            _arg_1.y = _arg_2.y;
            if (_arg_2.width != 0)
            {
                _arg_1.width = _arg_2.width;
            };
            if (_arg_2.height != 0)
            {
                _arg_1.height = _arg_2.height;
            };
        }

        public static function combineXML(_arg_1:XML, _arg_2:XML):void
        {
            var _local_4:XML;
            var _local_5:String;
            var _local_6:String;
            if (((_arg_2 == null) || (_arg_1 == null)))
            {
                return;
            };
            var _local_3:XMLList = _arg_2.attributes();
            for each (_local_4 in _local_3)
            {
                _local_5 = _local_4.name().toString();
                _local_6 = _local_4.toString();
                if ((!(_arg_1.hasOwnProperty(("@" + _local_5)))))
                {
                    _arg_1[("@" + _local_5)] = _local_6;
                };
            };
        }


    }
}//package com.pickgliss.utils

