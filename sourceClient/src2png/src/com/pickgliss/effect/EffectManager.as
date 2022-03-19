// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.EffectManager

package com.pickgliss.effect
{
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;

    public final class EffectManager 
    {

        private static var _instance:EffectManager;

        private var _effects:Dictionary;
        private var _effectIDCounter:int = 0;

        public function EffectManager()
        {
            this._effects = new Dictionary();
        }

        public static function get Instance():EffectManager
        {
            if (_instance == null)
            {
                _instance = new (EffectManager)();
            };
            return (_instance);
        }


        public function getEffectID():int
        {
            return (this._effectIDCounter++);
        }

        public function creatEffect(_arg_1:int, _arg_2:DisplayObject, ... _args):IEffect
        {
            var _local_4:IEffect = this.creatEffectByEffectType(_arg_1);
            _local_4.initEffect(_arg_2, _args);
            this._effects[_local_4.id] = _local_4;
            return (_local_4);
        }

        public function getEffectByTarget(_arg_1:DisplayObject):IEffect
        {
            var _local_2:IEffect;
            for each (_local_2 in this._effects)
            {
                if (_arg_1 == _local_2.target)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function removeEffect(_arg_1:IEffect):void
        {
            _arg_1.dispose();
            delete this._effects[_arg_1.id];
        }

        public function creatEffectByEffectType(_arg_1:int):IEffect
        {
            var _local_2:IEffect;
            switch (_arg_1)
            {
                case EffectTypes.ADD_MOVIE_EFFECT:
                    _local_2 = new AddMovieEffect(this.getEffectID());
                    break;
                case EffectTypes.SHINER_ANIMATION:
                    _local_2 = new ShinerAnimation(this.getEffectID());
                    break;
                case EffectTypes.ALPHA_SHINER_ANIMATION:
                    _local_2 = new AlphaShinerAnimation(this.getEffectID());
                    break;
                case EffectTypes.Linear_SHINER_ANIMATION:
                    _local_2 = new LinearShinerAnimation(this.getEffectID());
                    break;
            };
            return (_local_2);
        }


    }
}//package com.pickgliss.effect

