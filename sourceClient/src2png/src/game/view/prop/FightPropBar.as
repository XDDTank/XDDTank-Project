// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.FightPropBar

package game.view.prop
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.manager.SharedManager;
    import __AS3__.vec.Vector;
    import ddt.data.PropInfo;
    import game.model.LocalPlayer;
    import flash.display.DisplayObject;
    import ddt.events.LivingEvent;
    import org.aswing.KeyboardManager;
    import flash.events.KeyboardEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class FightPropBar extends Sprite implements Disposeable 
    {

        protected var _mode:int = SharedManager.Instance.propLayerMode;
        protected var _cells:Vector.<PropCell> = new Vector.<PropCell>();
        protected var _props:Vector.<PropInfo> = new Vector.<PropInfo>();
        protected var _self:LocalPlayer;
        protected var _background:DisplayObject;
        protected var _button:DisplayObject;
        protected var _enabled:Boolean = true;
        protected var _inited:Boolean = false;

        public function FightPropBar(_arg_1:LocalPlayer)
        {
            this._self = _arg_1;
            this.configUI();
            this.addEvent();
            this._inited = true;
        }

        public function enter():void
        {
            this.addEvent();
            this.enabled = this._self.propEnabled;
        }

        public function leaving():void
        {
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        protected function configUI():void
        {
            this.drawCells();
        }

        protected function addEvent():void
        {
            this._self.addEventListener(LivingEvent.ENERGY_CHANGED, this.__energyChange);
            this._self.addEventListener(LivingEvent.PROPENABLED_CHANGED, this.__enabledChanged);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_UP, this.__keyUp);
        }

        protected function __enabledChanged(_arg_1:LivingEvent):void
        {
            this.enabled = this._self.propEnabled;
        }

        protected function __keyDown(_arg_1:KeyboardEvent):void
        {
        }

        protected function __keyUp(_arg_1:KeyboardEvent):void
        {
        }

        protected function __die(_arg_1:LivingEvent):void
        {
        }

        protected function __changeAttack(_arg_1:LivingEvent):void
        {
        }

        protected function __energyChange(_arg_1:LivingEvent):void
        {
            if (this._enabled)
            {
                this.updatePropByEnergy();
            };
        }

        protected function updatePropByEnergy():void
        {
            var _local_1:PropCell;
            var _local_2:PropInfo;
            for each (_local_1 in this._cells)
            {
                if (_local_1.info)
                {
                    _local_2 = _local_1.info;
                    if (_local_2)
                    {
                        if (this._self.energy < _local_2.needEnergy)
                        {
                            _local_1.enabled = false;
                        }
                        else
                        {
                            _local_1.enabled = true;
                        };
                    };
                };
            };
        }

        protected function removeEvent():void
        {
            this._self.removeEventListener(LivingEvent.ENERGY_CHANGED, this.__energyChange);
            this._self.removeEventListener(LivingEvent.PROPENABLED_CHANGED, this.__enabledChanged);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_UP, this.__keyUp);
        }

        protected function drawLayer():void
        {
        }

        protected function clearCells():void
        {
            var _local_1:PropCell;
            for each (_local_1 in this._cells)
            {
                _local_1.info = null;
            };
        }

        protected function drawCells():void
        {
        }

        protected function __itemClicked(_arg_1:MouseEvent):void
        {
            StageReferance.stage.focus = null;
        }

        public function setMode(_arg_1:int):void
        {
            if (this._mode != _arg_1)
            {
                this._mode = _arg_1;
                this.drawLayer();
            };
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            var _local_2:PropCell;
            if (this._enabled != _arg_1)
            {
                this._enabled = _arg_1;
                if (this._enabled)
                {
                    filters = null;
                    this.updatePropByEnergy();
                }
                else
                {
                    filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
                };
                for each (_local_2 in this._cells)
                {
                    _local_2.enabled = this._enabled;
                };
            };
        }

        public function dispose():void
        {
            var _local_1:int;
            this.removeEvent();
            if (this._cells)
            {
                _local_1 = 0;
                while (_local_1 < this._cells.length)
                {
                    this._cells[_local_1].dispose();
                    this._cells[_local_1] = null;
                    _local_1++;
                };
            };
            this._cells = null;
            if (this._background)
            {
                ObjectUtils.disposeObject(this._background);
            };
            this._background = null;
            if (this._button)
            {
                ObjectUtils.disposeObject(this._button);
            };
            this._button = null;
            this._self = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.prop

