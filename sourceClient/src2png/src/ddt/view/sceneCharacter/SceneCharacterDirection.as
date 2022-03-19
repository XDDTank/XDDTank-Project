// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterDirection

package ddt.view.sceneCharacter
{
    import flash.geom.Point;

    public class SceneCharacterDirection 
    {

        public static const RT:SceneCharacterDirection = new SceneCharacterDirection("RT", false);
        public static const LT:SceneCharacterDirection = new SceneCharacterDirection("LT", true);
        public static const RB:SceneCharacterDirection = new SceneCharacterDirection("RB", true);
        public static const LB:SceneCharacterDirection = new SceneCharacterDirection("LB", false);

        private var _isMirror:Boolean;
        private var _type:String;

        public function SceneCharacterDirection(_arg_1:String, _arg_2:Boolean)
        {
            this._type = _arg_1;
            this._isMirror = _arg_2;
        }

        public static function getDirection(_arg_1:Point, _arg_2:Point):SceneCharacterDirection
        {
            var _local_3:Number = getDegrees(_arg_1, _arg_2);
            if (((_local_3 >= 0) && (_local_3 < 90)))
            {
                return (SceneCharacterDirection.RT);
            };
            if (((_local_3 >= 90) && (_local_3 < 180)))
            {
                return (SceneCharacterDirection.LT);
            };
            if (((_local_3 >= 180) && (_local_3 < 270)))
            {
                return (SceneCharacterDirection.LB);
            };
            if (((_local_3 >= 270) && (_local_3 < 360)))
            {
                return (SceneCharacterDirection.RB);
            };
            return (SceneCharacterDirection.RB);
        }

        private static function getDegrees(_arg_1:Point, _arg_2:Point):Number
        {
            var _local_3:Number = ((Math.atan2((_arg_1.y - _arg_2.y), (_arg_2.x - _arg_1.x)) * 180) / Math.PI);
            if (_local_3 < 0)
            {
                _local_3 = (_local_3 + 360);
            };
            return (_local_3);
        }


        public function get isMirror():Boolean
        {
            return (this._isMirror);
        }

        public function get type():String
        {
            return (this._type);
        }


    }
}//package ddt.view.sceneCharacter

