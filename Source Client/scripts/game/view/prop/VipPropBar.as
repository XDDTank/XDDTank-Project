package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.ToolPropInfo;
   import ddt.view.tips.ToolPropTip;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.GameModeType;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class VipPropBar extends FightPropBar
   {
       
      
      private var _canEnable:Boolean = true;
      
      private var _shooting:Boolean = false;
      
      private var cellt:WeaponPropCell;
      
      private var _DisappearMC:MovieClip;
      
      private var _toolPropTips:ToolPropTip;
      
      private var _toolPropInfo:ToolPropInfo;
      
      public function VipPropBar(param1:LocalPlayer)
      {
         super(param1);
         this.updatePropByEnergy();
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.game.PropDisappearPos");
         this._DisappearMC = ClassUtils.CreatInstance("asset.game.PropDisappear") as MovieClip;
         this._DisappearMC.addFrameScript(this._DisappearMC.totalFrames - 1,this.onPlay);
         this._DisappearMC.gotoAndStop(1);
         this._DisappearMC.buttonMode = true;
         this._DisappearMC.x = _loc1_.x;
         this._DisappearMC.y = _loc1_.y;
         this.cellt = new WeaponPropCell("t",_mode);
         _loc2_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPost");
         this.cellt.setPossiton(_loc2_.x,_loc2_.y);
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(17200);
         this.cellt.info = new PropInfo(_loc3_);
         this._toolPropTips = new ToolPropTip();
         this._toolPropInfo = new ToolPropInfo();
         this._toolPropInfo.info = _loc3_;
         this._toolPropTips.tipData = this._toolPropInfo;
         this._toolPropTips.visible = false;
         this._toolPropTips.x = _loc1_.x;
         this._toolPropTips.y = _loc1_.y;
         _self.fightToolBoxCount = 1;
         addChild(this._DisappearMC);
      }
      
      private function onPlay() : void
      {
         this._DisappearMC.stop();
         if(this._DisappearMC)
         {
            this._DisappearMC.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
            this._DisappearMC.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
            this._DisappearMC.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
            ObjectUtils.disposeObject(this._DisappearMC);
            this._DisappearMC = null;
         }
         if(this._toolPropTips)
         {
            this._toolPropTips.dispose();
            this._toolPropTips = null;
         }
         GameManager.Instance.dispatchEvent(new Event(GameManager.MOVE_PROPBAR));
      }
      
      override protected function addEvent() : void
      {
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         PlayerManager.Instance.Self.addEventListener(LivingEvent.FIGHT_TOOL_BOX_CHANGED,this.__fightToolBoxChanged);
         this.cellt.addEventListener(MouseEvent.CLICK,this.__itemClicked);
         this._DisappearMC.addEventListener(MouseEvent.CLICK,this.__itemClicked);
         this._DisappearMC.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._DisappearMC.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         super.addEvent();
      }
      
      private function __mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._toolPropTips)
         {
            this._toolPropTips.visible = true;
            LayerManager.Instance.addToLayer(this._toolPropTips,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._DisappearMC.localToGlobal(new Point(0,0));
            this._toolPropTips.x = _loc2_.x + this._DisappearMC.width;
            this._toolPropTips.y = _loc2_.y - this._DisappearMC.height;
         }
      }
      
      private function __mouseOutHandler(param1:MouseEvent) : void
      {
         if(this._toolPropTips)
         {
            this._toolPropTips.visible = false;
         }
      }
      
      override protected function removeEvent() : void
      {
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         PlayerManager.Instance.Self.removeEventListener(LivingEvent.FIGHT_TOOL_BOX_CHANGED,this.__fightToolBoxChanged);
         this.cellt.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         super.removeEvent();
      }
      
      override protected function __changeAttack(param1:LivingEvent) : void
      {
         if(_self.isAttacking)
         {
            this.updatePropByEnergy();
         }
      }
      
      private function __fightToolBoxChanged(param1:LivingEvent) : void
      {
         _self.fightToolBoxCount -= 1;
         PlayerManager.Instance.Self.fightToolBoxSkillNum -= 1;
         if(_self.fightToolBoxCount == 0 || PlayerManager.Instance.Self.fightToolBoxSkillNum == 0)
         {
            this.cellt.enabled = false;
         }
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(KeyboardManager.getInstance().isKeyDown(KeyStroke.VK_SPACE.getCode()))
         {
            this._shooting = true;
            if(this._DisappearMC == null && _self.isAttacking)
            {
               this.cellt.enabled = false;
               this.cellt.setGrayFilter();
            }
         }
         else
         {
            this._shooting = false;
         }
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:PropCell = param1.currentTarget as PropCell;
         if(this._shooting || this._DisappearMC.enabled == false)
         {
            return;
         }
         if(_self.isLiving && !_self.isAttacking)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
            return;
         }
         SoundManager.instance.play("008");
         _loc3_ = _self.useFightKitskill();
         this._DisappearMC.gotoAndPlay(2);
         NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_USE_T);
         if(!SavePointManager.Instance.savePoints[76])
         {
            SavePointManager.Instance.setSavePoint(76);
         }
         StageReferance.stage.focus = null;
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != KeyStroke.VK_T.getCode())
         {
            return;
         }
         if(this._shooting || this._DisappearMC == null || this._DisappearMC.enabled == false)
         {
            return;
         }
         if(_self.isLiving && !_self.isAttacking)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
            return;
         }
         switch(param1.keyCode)
         {
            case KeyStroke.VK_T.getCode():
               this.cellt.useProp();
         }
      }
      
      override protected function updatePropByEnergy() : void
      {
         var _loc1_:GameInfo = GameManager.Instance.Current;
         if(this._shooting || _self.isBoss || _loc1_.gameMode != 7 && _loc1_.gameMode != 8 && _loc1_.gameMode != 10 && _loc1_.gameMode != 18 && _loc1_.gameMode != GameModeType.MULTI_DUNGEON || _self.fightToolBoxCount <= 0 || !PlayerManager.Instance.Self.isUseFightByVip || PlayerManager.Instance.Self.fightToolBoxSkillNum <= 0)
         {
            this.disableFun();
         }
         else
         {
            this.enableFun();
         }
         if(_loc1_.roomType == RoomInfo.CONSORTION_MONSTER && PlayerManager.Instance.Self.IsVIP)
         {
            this.enableFun();
         }
      }
      
      private function disableFun() : void
      {
         this.cellt.enabled = false;
         this.cellt.setGrayFilter();
         if(this._DisappearMC == null)
         {
            return;
         }
         this._DisappearMC.enabled = false;
         this._DisappearMC.buttonMode = false;
         if(this._DisappearMC.currentFrame <= 2)
         {
            this._DisappearMC.gotoAndStop(1);
         }
         this._DisappearMC.filters = ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      private function enableFun() : void
      {
         this.cellt.enabled = true;
         if(this._DisappearMC == null)
         {
            return;
         }
         this._DisappearMC.enabled = true;
         this._DisappearMC.buttonMode = true;
         this._DisappearMC.filters = null;
         if(this._DisappearMC.currentFrame <= 2)
         {
            this._DisappearMC.gotoAndStop(2);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this.cellt)
         {
            ObjectUtils.disposeObject(this.cellt);
            this.cellt = null;
         }
         if(this._toolPropTips)
         {
            this._toolPropTips.dispose();
            this._toolPropTips = null;
         }
         this._toolPropInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
