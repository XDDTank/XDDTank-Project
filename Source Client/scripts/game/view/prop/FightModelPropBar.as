package game.view.prop
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.VipConfigInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.utils.PositionUtils;
   import fightToolBox.FightToolBoxController;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   import vip.VipController;
   
   public class FightModelPropBar extends FightPropBar
   {
      
      public static var POWER:String = "Q";
      
      public static var LEAD:String = "E";
      
      public static var NORMAL:String = "N";
       
      
      private var _fightModelCells:Vector.<BaseCell>;
      
      private var _powerDamageRatio:Number = 0;
      
      private var _headShotDamageRatio:Number = 0;
      
      private var _guideDamageIncrease:Number = 0;
      
      private var _currentModel:String;
      
      private var _seletecdTimer:Timer;
      
      public function FightModelPropBar(param1:LocalPlayer)
      {
         this._currentModel = LEAD;
         this._powerDamageRatio = FightToolBoxController.instance.model.powerDamageRatio;
         this._headShotDamageRatio = FightToolBoxController.instance.model.headShotDamageRatio;
         if(SharedManager.Instance.fightModelPropCell && SharedManager.Instance.fightModelPropCellSave != this._currentModel)
         {
            SharedManager.Instance.fightModelPropCellSave = LEAD;
            SharedManager.Instance.save();
         }
         this._currentModel = SharedManager.Instance.fightModelPropCellSave;
         if(VipController.instance.getPrivilegeByIndex(10))
         {
            this._powerDamageRatio += FightToolBoxController.instance.model.powerDamageIncrease;
            this._headShotDamageRatio += FightToolBoxController.instance.model.powerDamageIncrease;
            this._guideDamageIncrease += FightToolBoxController.instance.model.guideDamageIncrease;
         }
         this._powerDamageRatio = int(this._powerDamageRatio * 100);
         this._headShotDamageRatio = int(this._headShotDamageRatio * 100);
         this._guideDamageIncrease = int(this._guideDamageIncrease * 100);
         super(param1);
      }
      
      override public function enter() : void
      {
         if(SharedManager.Instance.fightModelPropCell && SharedManager.Instance.fightModelPropCellSave != this._currentModel)
         {
            SharedManager.Instance.fightModelPropCellSave = LEAD;
            SharedManager.Instance.save();
         }
         this._currentModel = SharedManager.Instance.fightModelPropCellSave;
         this.addEvent();
         enabled = _self.FightProEnabled;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         if(_self.FightProEnabled)
         {
            this.setCellSelected(param1.target.shortcutKey);
         }
      }
      
      private function setCellSelected(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FightModelPropCell = null;
         SoundManager.instance.playButtonSound();
         if(this._currentModel == param1)
         {
            return;
         }
         if(this._seletecdTimer && this._seletecdTimer.running)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.fightModelPropBar.error"));
            return;
         }
         if(_self.isLiving == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.RightPropView.prop"));
            return;
         }
         if(!this._seletecdTimer)
         {
            this._seletecdTimer = new Timer(1000,1);
            this._seletecdTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__selectedTimerComplete);
         }
         this._seletecdTimer.start();
         this._currentModel = param1;
         _loc2_ = param1 == POWER ? int(2) : int(1);
         SharedManager.Instance.fightModelPropCellSave = this._currentModel;
         SharedManager.Instance.save();
         GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.FIGHT_MODEL,_loc2_));
         if(SavePointManager.Instance.isInSavePoint(19) && this._currentModel == POWER)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWERMODE);
            GameManager.Instance.Current.selfGamePlayer.dispatchEvent(new LivingEvent(LivingEvent.SHOW_TIP_THREEANDADDONE));
            SavePointManager.Instance.setSavePoint(89);
         }
         for each(_loc3_ in this._fightModelCells)
         {
            _loc3_.setSelected(param1 == _loc3_.shortcutKey);
         }
      }
      
      private function __selectedTimerComplete(param1:TimerEvent) : void
      {
         if(this._seletecdTimer)
         {
            this._seletecdTimer.stop();
            this._seletecdTimer = null;
         }
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         if(!_enabled)
         {
            return;
         }
         if(_self.isBoss)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case KeyStroke.VK_Q.getCode():
               this.setCellSelected(POWER);
               break;
            case KeyStroke.VK_E.getCode():
               this.setCellSelected(LEAD);
         }
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.FightModelBack");
         addChild(_background);
         super.configUI();
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:FightModelPropCell = null;
         var _loc5_:FightModelPropCell = null;
         var _loc6_:FightModelPropCell = null;
         var _loc7_:VipConfigInfo = null;
         var _loc8_:int = 0;
         var _loc9_:VipConfigInfo = null;
         var _loc10_:int = 0;
         this._fightModelCells = new Vector.<BaseCell>();
         _loc1_ = new FightModelPropCell("Q");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("FightModelPropBar.powCellPos");
         PositionUtils.setPos(_loc1_,_loc2_);
         addChild(_loc1_);
         if(VipController.instance.getPrivilegeByIndex(10))
         {
            _loc7_ = VipPrivilegeConfigManager.Instance.getById(10);
            _loc8_ = int(_loc7_["Level" + PlayerManager.Instance.Self.VIPLevel]);
            _loc1_.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.power",_loc8_) + LanguageMgr.GetTranslation("fightModelPropBar.cellTips.powerDamage",this._headShotDamageRatio - 100);
         }
         else
         {
            _loc1_.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.powerDamage",this._headShotDamageRatio - 100);
         }
         _loc1_.tipStyle = "ddt.view.tips.OneLineTip";
         _loc1_.tipDirctions = "0";
         var _loc3_:FightModelPropCell = new FightModelPropCell("E");
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("FightModelPropBar.leadCellPos");
         PositionUtils.setPos(_loc3_,_loc4_);
         addChild(_loc3_);
         if(VipController.instance.getPrivilegeByIndex(11))
         {
            _loc9_ = VipPrivilegeConfigManager.Instance.getById(11);
            _loc10_ = int(_loc9_["Level" + PlayerManager.Instance.Self.VIPLevel]);
            _loc3_.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.leadDamage",_loc10_) + LanguageMgr.GetTranslation("fightModelPropBar.cellTips.lead");
         }
         else
         {
            _loc3_.tipData = LanguageMgr.GetTranslation("fightModelPropBar.cellTips.lead");
         }
         _loc3_.tipStyle = "ddt.view.tips.OneLineTip";
         _loc3_.tipDirctions = "0";
         this._fightModelCells.push(_loc1_);
         this._fightModelCells.push(_loc3_);
         for each(_loc5_ in this._fightModelCells)
         {
            _loc5_.addEventListener(MouseEvent.CLICK,this.__mouseClick);
         }
         super.drawCells();
         for each(_loc6_ in this._fightModelCells)
         {
            _loc6_.setSelected(this._currentModel == _loc6_.shortcutKey);
         }
         this.showGuide();
      }
      
      private function showGuide() : void
      {
         if(!SavePointManager.Instance.isInSavePoint(4))
         {
         }
         this.setCellSelected(this._currentModel);
      }
      
      public function setPropCellVisible(param1:Boolean, ... rest) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            this._fightModelCells[rest[_loc3_]].visible = param1;
            _loc3_++;
         }
         if(rest.length == 2 && !param1)
         {
            _background.visible = false;
         }
         else
         {
            _background.visible = true;
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:FightModelPropCell = null;
         NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_POWERMODE);
         this.removeKeyRepose(false);
         for each(_loc1_ in this._fightModelCells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__mouseClick);
            _loc1_.dispose();
         }
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this.__selectedTimerComplete(null);
      }
      
      public function removeKeyRepose(param1:Boolean) : void
      {
         if(!param1)
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
         if(param1)
         {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
      }
   }
}
