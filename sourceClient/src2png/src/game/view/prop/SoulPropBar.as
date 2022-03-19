// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.SoulPropBar

package game.view.prop
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import game.model.LocalPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.LivingEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import ddt.data.UsePropErrorCode;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.PropInfo;
    import ddt.manager.ItemManager;
    import __AS3__.vec.*;

    public class SoulPropBar extends FightPropBar 
    {

        protected var _soulCells:Vector.<SoulPropCell> = new Vector.<SoulPropCell>();
        private var _propDatas:Array;
        private var _back:DisplayObject;
        private var _msgShape:DisplayObject;
        private var _lockScreen:DisplayObject;

        public function SoulPropBar(_arg_1:LocalPlayer)
        {
            super(_arg_1);
        }

        override protected function configUI():void
        {
            this._back = ComponentFactory.Instance.creatBitmap("asset.game.prop.SoulBack");
            addChild(this._back);
            this._lockScreen = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.LockScreen");
            addChild(this._lockScreen);
            super.configUI();
        }

        override protected function addEvent():void
        {
            _self.addEventListener(LivingEvent.PSYCHIC_CHANGED, this.__psychicChanged);
            _self.addEventListener(LivingEvent.SOUL_PROP_ENABEL_CHANGED, this.__enableChanged);
        }

        override protected function removeEvent():void
        {
            var _local_1:SoulPropCell;
            _self.removeEventListener(LivingEvent.PSYCHIC_CHANGED, this.__psychicChanged);
            _self.removeEventListener(LivingEvent.SOUL_PROP_ENABEL_CHANGED, this.__enableChanged);
            for each (_local_1 in this._soulCells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__itemClicked);
            };
        }

        override public function enter():void
        {
            this.setProps();
            this.updatePropByPsychic();
            super.enter();
        }

        private function __psychicChanged(_arg_1:LivingEvent):void
        {
            if (_enabled)
            {
                this.updatePropByPsychic();
            };
        }

        private function __enableChanged(_arg_1:LivingEvent):void
        {
            enabled = _self.soulPropEnabled;
            if (_enabled)
            {
                this.updatePropByPsychic();
            };
        }

        private function updatePropByPsychic():void
        {
            var _local_1:PropCell;
            for each (_local_1 in this._soulCells)
            {
                if (((!(_local_1.info == null)) && (_self.psychic >= _local_1.info.needPsychic)))
                {
                    _local_1.enabled = true;
                }
                else
                {
                    _local_1.enabled = false;
                };
            };
        }

        override protected function drawCells():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_5:SoulPropCell;
            var _local_1:int;
            var _local_4:Point = new Point(4, 4);
            while (_local_1 < 20)
            {
                _local_5 = new SoulPropCell();
                _local_5.addEventListener(MouseEvent.CLICK, this.__itemClicked);
                _local_2 = ((_local_1 % 10) * (_local_5.width + 1));
                if (_local_1 >= 10)
                {
                    _local_3 = (_local_5.height + 2);
                };
                _local_5.setPossiton((_local_2 + _local_4.x), (_local_3 + _local_4.y));
                addChild(_local_5);
                this._soulCells.push(_local_5);
                _local_1++;
            };
        }

        override protected function __itemClicked(_arg_1:MouseEvent):void
        {
            var _local_2:SoulPropCell;
            var _local_3:String;
            if (_enabled)
            {
                if (this._msgShape)
                {
                    ObjectUtils.disposeObject(this._msgShape);
                    this._msgShape = null;
                };
                _local_2 = (_arg_1.currentTarget as SoulPropCell);
                SoundManager.instance.play("008");
                _local_3 = _self.useProp(_local_2.info, 0);
                if (((!(_local_3 == UsePropErrorCode.Done)) && (!(_local_3 == UsePropErrorCode.None))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(("tank.game.prop." + _local_3)));
                };
                super.__itemClicked(_arg_1);
            };
        }

        public function setProps():void
        {
            var _local_2:PropInfo;
            var _local_1:int;
            while (_local_1 < this._propDatas.length)
            {
                _local_2 = new PropInfo(ItemManager.Instance.getTemplateById(this._propDatas[_local_1]));
                _local_2.Place = -1;
                this._soulCells[_local_1].info = _local_2;
                this._soulCells[_local_1].enabled = false;
                _local_1++;
            };
        }

        public function set props(_arg_1:String):void
        {
            this._propDatas = _arg_1.split(",");
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._lockScreen);
            this._lockScreen = null;
        }


    }
}//package game.view.prop

