// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.control.FightControlBar

package game.view.control
{
    import com.pickgliss.ui.core.Disposeable;
    import game.model.LocalPlayer;
    import flash.display.DisplayObjectContainer;
    import com.pickgliss.utils.ObjectUtils;

    public class FightControlBar implements Disposeable 
    {

        public static const LIVE:int = 0;
        public static const SOUL:int = 1;

        private var _statePool:Object = new Object();
        private var _self:LocalPlayer;
        private var _state:int;
        private var _container:DisplayObjectContainer;
        private var _current:ControlState;
        private var _next:ControlState;

        public function FightControlBar(_arg_1:LocalPlayer, _arg_2:DisplayObjectContainer)
        {
            this._self = _arg_1;
            this._container = _arg_2;
            this.configUI();
            this.addEvent();
            super();
        }

        private static function getFightControlState(_arg_1:int, _arg_2:LocalPlayer):ControlState
        {
            switch (_arg_1)
            {
                case LIVE:
                    return (new LiveState(_arg_2));
                case SOUL:
                    return (new SoulState(_arg_2));
                default:
                    return (null);
            };
        }


        private function configUI():void
        {
        }

        private function addEvent():void
        {
        }

        private function removeEvent():void
        {
        }

        public function setState(_arg_1:int):ControlState
        {
            var _local_2:ControlState;
            if ((!(this.hasState(_arg_1))))
            {
                _local_2 = getFightControlState(_arg_1, this._self);
                this._statePool[String(_arg_1)] = (this._next = _local_2);
            }
            else
            {
                this._next = this._statePool[String(_arg_1)];
            };
            if (this._next == this._current)
            {
                return (this._current);
            };
            if (this._current != null)
            {
                this._current.leaving(this.leavingComplete);
            }
            else
            {
                this.enterNext(this._next);
            };
            return (this._current);
        }

        private function hasState(_arg_1:int):Boolean
        {
            return (this._statePool.hasOwnProperty(String(_arg_1)));
        }

        private function enterNext(_arg_1:ControlState):void
        {
            this._current = _arg_1;
            this._current.enter(this._container);
            this._next = null;
        }

        private function leavingComplete():void
        {
            this.enterNext(this._next);
        }

        private function enterComplete():void
        {
        }

        public function dispose():void
        {
            var _local_1:String;
            this.removeEvent();
            for (_local_1 in this._statePool)
            {
                ObjectUtils.disposeObject(this._statePool[_local_1]);
                delete this._statePool[_local_1];
            };
        }

        public function get current():ControlState
        {
            return (this._current);
        }


    }
}//package game.view.control

