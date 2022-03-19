// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//par.ShapeManager

package par
{
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class ShapeManager 
    {

        public static var list:Array = [];
        private static var _ready:Boolean;
        private static var objects:Dictionary = new Dictionary();


        public static function get ready():Boolean
        {
            return (_ready);
        }

        public static function clear():void
        {
            list = [];
            _ready = false;
            objects = new Dictionary();
            ParticleManager.clear();
        }

        public static function setup():void
        {
            var cls:Object;
            try
            {
                cls = ParticleManager.Domain.getDefinition("ParticalShapLib");
                if (cls["data"])
                {
                    list = cls["data"];
                    _ready = true;
                };
            }
            catch(err:Error)
            {
            };
        }

        public static function create(_arg_1:uint):DisplayObject
        {
            var _local_2:Sprite;
            var _local_3:Class;
            if (((_arg_1 < 0) || (_arg_1 >= list.length)))
            {
                _local_2 = new Sprite();
                _local_2.graphics.beginFill(0);
                _local_2.graphics.drawCircle(0, 0, 10);
                _local_2.graphics.endFill();
                return (_local_2);
            };
            _local_3 = list[_arg_1]["data"];
            return (creatShape(_local_3));
        }

        private static function creatShape(_arg_1:*):DisplayObject
        {
            var _local_2:String;
            if ((_arg_1 is String))
            {
                _local_2 = _arg_1;
            }
            else
            {
                _local_2 = getQualifiedClassName(_arg_1);
            };
            if (objects[_local_2] == null)
            {
                objects[_local_2] = new Vector.<DisplayObject>();
            };
            var _local_3:Vector.<DisplayObject> = objects[_local_2];
            return (getFreeObject(_local_3, _local_2));
        }

        private static function getFreeObject(objects:Vector.<DisplayObject>, classname:String):DisplayObject
        {
            var object:* = undefined;
            var len:int = objects.length;
            var i:int;
            while (i < objects.length)
            {
                if (objects[i].parent == null)
                {
                    return (objects[i]);
                };
                i = (i + 1);
            };
            var objectClass:Class = (ParticleManager.Domain.getDefinition(classname) as Class);
            try
            {
                object = new (objectClass)();
                objects.push(object);
            }
            catch(e:Error)
            {
                throw (new Error((classname + "isn't exist!")));
            };
            return (object);
        }


    }
}//package par

