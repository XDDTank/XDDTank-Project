// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.BaseStageTween

package game.animations
{
    import flash.geom.Point;
    import flash.display.DisplayObject;

    public class BaseStageTween implements IStageTween 
    {

        protected var _target:Point;
        protected var _prepared:Boolean = false;
        protected var _isFinished:Boolean;

        public function BaseStageTween(_arg_1:TweenObject=null)
        {
            this._isFinished = false;
            if (_arg_1)
            {
                this.initData(_arg_1);
            };
        }

        public function get type():String
        {
            return ("BaseStageTween");
        }

        public function initData(_arg_1:TweenObject):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            this.copyPropertyFromData(_arg_1);
            this._prepared = true;
        }

        public function update(_arg_1:DisplayObject):Point
        {
            return (null);
        }

        public function set target(_arg_1:Point):void
        {
            this._target = _arg_1;
            this._prepared = true;
        }

        public function get target():Point
        {
            return (this._target);
        }

        public function copyPropertyFromData(_arg_1:TweenObject):void
        {
            var _local_2:String;
            for each (_local_2 in this.propertysNeed)
            {
                if (_arg_1[_local_2])
                {
                    this[_local_2] = _arg_1[_local_2];
                };
            };
        }

        protected function get propertysNeed():Array
        {
            return (["target"]);
        }

        public function get isFinished():Boolean
        {
            return (this._isFinished);
        }


    }
}//package game.animations

