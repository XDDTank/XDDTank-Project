// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.VipPropBar

package game.view.prop
{
    import flash.display.MovieClip;
    import ddt.view.tips.ToolPropTip;
    import ddt.view.tips.ToolPropInfo;
    import game.model.LocalPlayer;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.PropInfo;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import game.GameManager;
    import flash.events.Event;
    import ddt.events.LivingEvent;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.LayerManager;
    import org.aswing.KeyboardManager;
    import org.aswing.KeyStroke;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.SavePointManager;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.KeyboardEvent;
    import game.model.GameInfo;
    import game.model.GameModeType;
    import room.model.RoomInfo;

    public class VipPropBar extends FightPropBar 
    {

        private var _canEnable:Boolean = true;
        private var _shooting:Boolean = false;
        private var cellt:WeaponPropCell;
        private var _DisappearMC:MovieClip;
        private var _toolPropTips:ToolPropTip;
        private var _toolPropInfo:ToolPropInfo;

        public function VipPropBar(_arg_1:LocalPlayer)
        {
            super(_arg_1);
            this.updatePropByEnergy();
        }

        override protected function drawCells():void
        {
            var _local_1:Point;
            var _local_2:Point;
            _local_1 = ComponentFactory.Instance.creatCustomObject("asset.game.PropDisappearPos");
            this._DisappearMC = (ClassUtils.CreatInstance("asset.game.PropDisappear") as MovieClip);
            this._DisappearMC.addFrameScript((this._DisappearMC.totalFrames - 1), this.onPlay);
            this._DisappearMC.gotoAndStop(1);
            this._DisappearMC.buttonMode = true;
            this._DisappearMC.x = _local_1.x;
            this._DisappearMC.y = _local_1.y;
            this.cellt = new WeaponPropCell("t", _mode);
            _local_2 = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPost");
            this.cellt.setPossiton(_local_2.x, _local_2.y);
            var _local_3:ItemTemplateInfo = ItemManager.Instance.getTemplateById(17200);
            this.cellt.info = new PropInfo(_local_3);
            this._toolPropTips = new ToolPropTip();
            this._toolPropInfo = new ToolPropInfo();
            this._toolPropInfo.info = _local_3;
            this._toolPropTips.tipData = this._toolPropInfo;
            this._toolPropTips.visible = false;
            this._toolPropTips.x = _local_1.x;
            this._toolPropTips.y = _local_1.y;
            _self.fightToolBoxCount = 1;
            addChild(this._DisappearMC);
        }

        private function onPlay():void
        {
            this._DisappearMC.stop();
            if (this._DisappearMC)
            {
                this._DisappearMC.removeEventListener(MouseEvent.CLICK, this.__itemClicked);
                this._DisappearMC.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
                this._DisappearMC.removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
                ObjectUtils.disposeObject(this._DisappearMC);
                this._DisappearMC = null;
            };
            if (this._toolPropTips)
            {
                this._toolPropTips.dispose();
                this._toolPropTips = null;
            };
            GameManager.Instance.dispatchEvent(new Event(GameManager.MOVE_PROPBAR));
        }

        override protected function addEvent():void
        {
            _self.addEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
            PlayerManager.Instance.Self.addEventListener(LivingEvent.FIGHT_TOOL_BOX_CHANGED, this.__fightToolBoxChanged);
            this.cellt.addEventListener(MouseEvent.CLICK, this.__itemClicked);
            this._DisappearMC.addEventListener(MouseEvent.CLICK, this.__itemClicked);
            this._DisappearMC.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            this._DisappearMC.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            addEventListener(Event.ENTER_FRAME, this.__enterFrame);
            super.addEvent();
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._toolPropTips)
            {
                this._toolPropTips.visible = true;
                LayerManager.Instance.addToLayer(this._toolPropTips, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._DisappearMC.localToGlobal(new Point(0, 0));
                this._toolPropTips.x = (_local_2.x + this._DisappearMC.width);
                this._toolPropTips.y = (_local_2.y - this._DisappearMC.height);
            };
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            if (this._toolPropTips)
            {
                this._toolPropTips.visible = false;
            };
        }

        override protected function removeEvent():void
        {
            _self.removeEventListener(LivingEvent.ATTACKING_CHANGED, this.__changeAttack);
            PlayerManager.Instance.Self.removeEventListener(LivingEvent.FIGHT_TOOL_BOX_CHANGED, this.__fightToolBoxChanged);
            this.cellt.removeEventListener(MouseEvent.CLICK, this.__itemClicked);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            super.removeEvent();
        }

        override protected function __changeAttack(_arg_1:LivingEvent):void
        {
            if (_self.isAttacking)
            {
                this.updatePropByEnergy();
            };
        }

        private function __fightToolBoxChanged(_arg_1:LivingEvent):void
        {
            _self.fightToolBoxCount = (_self.fightToolBoxCount - 1);
            PlayerManager.Instance.Self.fightToolBoxSkillNum = (PlayerManager.Instance.Self.fightToolBoxSkillNum - 1);
            if (((_self.fightToolBoxCount == 0) || (PlayerManager.Instance.Self.fightToolBoxSkillNum == 0)))
            {
                this.cellt.enabled = false;
            };
        }

        private function __enterFrame(_arg_1:Event):void
        {
            if (KeyboardManager.getInstance().isKeyDown(KeyStroke.VK_SPACE.getCode()))
            {
                this._shooting = true;
                if (((this._DisappearMC == null) && (_self.isAttacking)))
                {
                    this.cellt.enabled = false;
                    this.cellt.setGrayFilter();
                };
            }
            else
            {
                this._shooting = false;
            };
        }

        override protected function __itemClicked(_arg_1:MouseEvent):void
        {
            var _local_3:String;
            var _local_2:PropCell = (_arg_1.currentTarget as PropCell);
            if (((this._shooting) || (this._DisappearMC.enabled == false)))
            {
                return;
            };
            if (((_self.isLiving) && (!(_self.isAttacking))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                return;
            };
            SoundManager.instance.play("008");
            _local_3 = _self.useFightKitskill();
            this._DisappearMC.gotoAndPlay(2);
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_USE_T);
            if ((!(SavePointManager.Instance.savePoints[76])))
            {
                SavePointManager.Instance.setSavePoint(76);
            };
            StageReferance.stage.focus = null;
        }

        override protected function __keyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode != KeyStroke.VK_T.getCode())
            {
                return;
            };
            if ((((this._shooting) || (this._DisappearMC == null)) || (this._DisappearMC.enabled == false)))
            {
                return;
            };
            if (((_self.isLiving) && (!(_self.isAttacking))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
                return;
            };
            switch (_arg_1.keyCode)
            {
                case KeyStroke.VK_T.getCode():
                    this.cellt.useProp();
                    return;
            };
        }

        override protected function updatePropByEnergy():void
        {
            var _local_1:GameInfo = GameManager.Instance.Current;
            if (((((((this._shooting) || (_self.isBoss)) || (((((!(_local_1.gameMode == 7)) && (!(_local_1.gameMode == 8))) && (!(_local_1.gameMode == 10))) && (!(_local_1.gameMode == 18))) && (!(_local_1.gameMode == GameModeType.MULTI_DUNGEON)))) || (_self.fightToolBoxCount <= 0)) || (!(PlayerManager.Instance.Self.isUseFightByVip))) || (PlayerManager.Instance.Self.fightToolBoxSkillNum <= 0)))
            {
                this.disableFun();
            }
            else
            {
                this.enableFun();
            };
            if (((_local_1.roomType == RoomInfo.CONSORTION_MONSTER) && (PlayerManager.Instance.Self.IsVIP)))
            {
                this.enableFun();
            };
        }

        private function disableFun():void
        {
            this.cellt.enabled = false;
            this.cellt.setGrayFilter();
            if (this._DisappearMC == null)
            {
                return;
            };
            this._DisappearMC.enabled = false;
            this._DisappearMC.buttonMode = false;
            if (this._DisappearMC.currentFrame <= 2)
            {
                this._DisappearMC.gotoAndStop(1);
            };
            this._DisappearMC.filters = ComponentFactory.Instance.creatFilters("grayFilter");
        }

        private function enableFun():void
        {
            this.cellt.enabled = true;
            if (this._DisappearMC == null)
            {
                return;
            };
            this._DisappearMC.enabled = true;
            this._DisappearMC.buttonMode = true;
            this._DisappearMC.filters = null;
            if (this._DisappearMC.currentFrame <= 2)
            {
                this._DisappearMC.gotoAndStop(2);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this.cellt)
            {
                ObjectUtils.disposeObject(this.cellt);
                this.cellt = null;
            };
            if (this._toolPropTips)
            {
                this._toolPropTips.dispose();
                this._toolPropTips = null;
            };
            this._toolPropInfo = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.prop

