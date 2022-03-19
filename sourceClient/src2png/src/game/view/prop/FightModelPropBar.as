// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.FightModelPropBar

package game.view.prop
{
    import __AS3__.vec.Vector;
    import bagAndInfo.cell.BaseCell;
    import fightToolBox.FightToolBoxController;
    import flash.utils.Timer;
    import ddt.manager.SharedManager;
    import vip.VipController;
    import game.model.LocalPlayer;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.events.TimerEvent;
    import game.GameManager;
    import ddt.events.GameEvent;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.events.LivingEvent;
    import org.aswing.KeyStroke;
    import flash.events.KeyboardEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.VipConfigInfo;
    import flash.geom.Point;
    import ddt.utils.PositionUtils;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.manager.PlayerManager;
    import org.aswing.KeyboardManager;
    import __AS3__.vec.*;

    public class FightModelPropBar extends FightPropBar 
    {

        public static var POWER:String = "Q";
        public static var LEAD:String = "E";
        public static var NORMAL:String = "N";

        private var _fightModelCells:Vector.<BaseCell>;
        private var _powerDamageRatio:Number = FightToolBoxController.instance.model.powerDamageRatio;//0
        private var _headShotDamageRatio:Number = FightToolBoxController.instance.model.headShotDamageRatio;//0
        private var _guideDamageIncrease:Number = 0;
        private var _currentModel:String = LEAD;
        private var _seletecdTimer:Timer;

        public function FightModelPropBar(_arg_1:LocalPlayer)
        {
            if (((SharedManager.Instance.fightModelPropCell) && (!(SharedManager.Instance.fightModelPropCellSave == this._currentModel))))
            {
                SharedManager.Instance.fightModelPropCellSave = LEAD;
                SharedManager.Instance.save();
            };
            this._currentModel = SharedManager.Instance.fightModelPropCellSave;
            if (VipController.instance.getPrivilegeByIndex(10))
            {
                this._powerDamageRatio = (this._powerDamageRatio + FightToolBoxController.instance.model.powerDamageIncrease);
                this._headShotDamageRatio = (this._headShotDamageRatio + FightToolBoxController.instance.model.powerDamageIncrease);
                this._guideDamageIncrease = (this._guideDamageIncrease + FightToolBoxController.instance.model.guideDamageIncrease);
            };
            this._powerDamageRatio = int((this._powerDamageRatio * 100));
            this._headShotDamageRatio = int((this._headShotDamageRatio * 100));
            this._guideDamageIncrease = int((this._guideDamageIncrease * 100));
            super(_arg_1);
        }

        override public function enter():void
        {
            if (((SharedManager.Instance.fightModelPropCell) && (!(SharedManager.Instance.fightModelPropCellSave == this._currentModel))))
            {
                SharedManager.Instance.fightModelPropCellSave = LEAD;
                SharedManager.Instance.save();
            };
            this._currentModel = SharedManager.Instance.fightModelPropCellSave;
            this.addEvent();
            enabled = _self.FightProEnabled;
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
        }

        override protected function addEvent():void
        {
            super.addEvent();
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            if (_self.FightProEnabled)
            {
                this.setCellSelected(_arg_1.target.shortcutKey);
            };
        }

        private function setCellSelected(_arg_1:String):void
        {
            var _local_2:int;
            var _local_3:FightModelPropCell;
            SoundManager.instance.playButtonSound();
            if (this._currentModel == _arg_1)
            {
                return;
            };
            if (((this._seletecdTimer) && (this._seletecdTimer.running)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.fightModelPropBar.error"));
                return;
            };
            if (_self.isLiving == false)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.RightPropView.prop"));
                return;
            };
            if ((!(this._seletecdTimer)))
            {
                this._seletecdTimer = new Timer(1000, 1);
                this._seletecdTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__selectedTimerComplete);
            };
            this._seletecdTimer.start();
            this._currentModel = _arg_1;
            _local_2 = ((_arg_1 == POWER) ? 2 : 1);
            SharedManager.Instance.fightModelPropCellSave = this._currentModel;
            SharedManager.Instance.save();
            GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.FIGHT_MODEL, _local_2));
            if (((SavePointManager.Instance.isInSavePoint(19)) && (this._currentModel == POWER)))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWERMODE);
                GameManager.Instance.Current.selfGamePlayer.dispatchEvent(new LivingEvent(LivingEvent.SHOW_TIP_THREEANDADDONE));
                SavePointManager.Instance.setSavePoint(89);
            };
            for each (_local_3 in this._fightModelCells)
            {
                _local_3.setSelected((_arg_1 == _local_3.shortcutKey));
            };
        }

        private function __selectedTimerComplete(_arg_1:TimerEvent):void
        {
            if (this._seletecdTimer)
            {
                this._seletecdTimer.stop();
                this._seletecdTimer = null;
            };
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            if ((!(_enabled)))
            {
                return;
            };
            if (_self.isBoss)
            {
                return;
            };
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_Q.getCode():
                    this.setCellSelected(POWER);
                    return;
                case KeyStroke.VK_E.getCode():
                    this.setCellSelected(LEAD);
                    return;
            };
        }

        override protected function configUI():void
        {
            _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.FightModelBack");
            addChild(_background);
            super.configUI();
        }

        override protected function drawCells():void
        {
            var _local_1:FightModelPropCell;
            var _local_5:FightModelPropCell;
            var _local_6:FightModelPropCell;
            var _local_7:VipConfigInfo;
            var _local_8:int;
            var _local_9:VipConfigInfo;
            var _local_10:int;
            this._fightModelCells = new Vector.<BaseCell>();
            _local_1 = new FightModelPropCell("Q");
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("FightModelPropBar.powCellPos");
            PositionUtils.setPos(_local_1, _local_2);
            addChild(_local_1);
            if (VipController.instance.getPrivilegeByIndex(10))
            {
                _local_7 = VipPrivilegeConfigManager.Instance.getById(10);
                _local_8 = int(_local_7[("Level" + PlayerManager.Instance.Self.VIPLevel)]);
                _local_1.tipData = (LanguageMgr.GetTranslation("fightModelPropBar.cellTips.power", _local_8) + LanguageMgr.GetTranslation("fightModelPropBar.cellTips.powerDamage", (this._headShotDamageRatio - 100)));
            }
            else
            {
                _local_1.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.powerDamage", (this._headShotDamageRatio - 100));
            };
            _local_1.tipStyle = "ddt.view.tips.OneLineTip";
            _local_1.tipDirctions = "0";
            var _local_3:FightModelPropCell = new FightModelPropCell("E");
            var _local_4:Point = ComponentFactory.Instance.creatCustomObject("FightModelPropBar.leadCellPos");
            PositionUtils.setPos(_local_3, _local_4);
            addChild(_local_3);
            if (VipController.instance.getPrivilegeByIndex(11))
            {
                _local_9 = VipPrivilegeConfigManager.Instance.getById(11);
                _local_10 = int(_local_9[("Level" + PlayerManager.Instance.Self.VIPLevel)]);
                _local_3.tipData = (LanguageMgr.GetTranslation("fightModelPropBar.cellTips.leadDamage", _local_10) + LanguageMgr.GetTranslation("fightModelPropBar.cellTips.lead"));
            }
            else
            {
                _local_3.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.lead");
            };
            _local_3.tipStyle = "ddt.view.tips.OneLineTip";
            _local_3.tipDirctions = "0";
            this._fightModelCells.push(_local_1);
            this._fightModelCells.push(_local_3);
            for each (_local_5 in this._fightModelCells)
            {
                _local_5.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            };
            super.drawCells();
            for each (_local_6 in this._fightModelCells)
            {
                _local_6.setSelected((this._currentModel == _local_6.shortcutKey));
            };
            this.showGuide();
        }

        private function showGuide():void
        {
            if (SavePointManager.Instance.isInSavePoint(4))
            {
            };
            this.setCellSelected(this._currentModel);
        }

        public function setPropCellVisible(_arg_1:Boolean, ... _args):void
        {
            var _local_3:int;
            while (_local_3 < _args.length)
            {
                this._fightModelCells[_args[_local_3]].visible = _arg_1;
                _local_3++;
            };
            if (((_args.length == 2) && (!(_arg_1))))
            {
                _background.visible = false;
            }
            else
            {
                _background.visible = true;
            };
        }

        override public function dispose():void
        {
            var _local_1:FightModelPropCell;
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWERMODE);
            this.removeKeyRepose(false);
            for each (_local_1 in this._fightModelCells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__mouseClick);
                _local_1.dispose();
            };
            super.dispose();
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            this.__selectedTimerComplete(null);
        }

        public function removeKeyRepose(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            };
            if (_arg_1)
            {
                KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDown);
            };
        }


    }
}//package game.view.prop

