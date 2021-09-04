package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class WeaponPropBar extends FightPropBar
   {
       
      
      private var _canEnable:Boolean = true;
      
      private var _localFlyVisible:Boolean = true;
      
      private var _localDeputyWeaponVisible:Boolean = true;
      
      private var _localVisible:Boolean = true;
      
      public function WeaponPropBar(param1:LocalPlayer)
      {
         super(param1);
         this._canEnable = this.weaponEnabled();
         this.updatePropByEnergy();
      }
      
      private function weaponEnabled() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:ItemTemplateInfo = _self.currentDeputyWeaponInfo.Template;
         if(_loc1_.TemplateID == EquipType.WishKingBlessing)
         {
            _loc2_ = RoomManager.Instance.current.type;
            if(_loc2_ == RoomInfo.DUNGEON_ROOM || _loc2_ == RoomInfo.WORLD_BOSS_FIGHT || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               return false;
            }
            return true;
         }
         return true;
      }
      
      override protected function updatePropByEnergy() : void
      {
         _cells[0].enabled = _self.flyEnabled;
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
            _cells[1].setGrayFilter();
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
         var _loc1_:GameInfo = GameManager.Instance.Current;
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         if(!this._localVisible)
         {
            return;
         }
         var _loc2_:PropCell = param1.currentTarget as PropCell;
         SoundManager.instance.play("008");
         var _loc3_:int = _cells.indexOf(_loc2_);
         switch(_loc3_)
         {
            case 0:
               if(!this._localFlyVisible)
               {
                  return;
               }
               _loc4_ = _self.useFly();
               break;
            case 1:
               if(!this._localDeputyWeaponVisible)
               {
                  return;
               }
               _loc4_ = _self.useDeputyWeapon();
            case 2:
               break;
            default:
               _loc4_ = UsePropErrorCode.None;
         }
         if(_loc4_ == UsePropErrorCode.FlyNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.flyCoolDown));
         }
         else if(_loc4_ == UsePropErrorCode.DeputyWeaponNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.deputyWeaponCoolDown));
         }
         else if(_loc4_ == UsePropErrorCode.DeputyWeaponEmpty)
         {
            switch(_self.selfInfo.DeputyWeapon.TemplateID)
            {
               case EquipType.Angle:
               case EquipType.TrueAngle:
               case EquipType.ExllenceAngle:
               case EquipType.FlyAngle:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse"));
                  break;
               case EquipType.TrueShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse2"));
                  break;
               case EquipType.ExcellentShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse3"));
                  break;
               case EquipType.WishKingBlessing:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse4"));
            }
         }
         else if(_loc4_ != UsePropErrorCode.None)
         {
            if(_loc4_ != null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc4_));
            }
         }
         else if(_loc3_ == 0)
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_PLANE);
            if(SavePointManager.Instance.isInSavePoint(19) && GameManager.Instance.Current.missionInfo.missionIndex == 2)
            {
               GameManager.Instance.Current.selfGamePlayer.dispatchEvent(new LivingEvent(LivingEvent.USE_PLANE));
               SavePointManager.Instance.setSavePoint(91);
            }
         }
         StageReferance.stage.focus = null;
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case KeyStroke.VK_F.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_R.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_T.getCode():
         }
         super.__keyDown(param1);
      }
      
      override protected function addEvent() : void
      {
         var _loc1_:PropCell = null;
         _self.addEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.addEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         _self.addEventListener(LivingEvent.WEAPONENABLED_CHANGE,this.__weaponEnabledChanged);
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         for each(_loc1_ in _cells)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.addEvent();
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(KeyboardManager.getInstance().isKeyDown(KeyStroke.VK_SPACE.getCode()))
         {
            if(!_self.canNormalShoot)
            {
               return;
            }
         }
      }
      
      override protected function __changeAttack(param1:LivingEvent) : void
      {
         if(_self.isAttacking)
         {
            this.updatePropByEnergy();
         }
      }
      
      protected function __weaponEnabledChanged(param1:Event) : void
      {
         enabled = _self.propEnabled && _self.weaponPropEnbled;
      }
      
      private function __setDeputyWeaponNumber(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         _cells[1].enabled = _loc2_ != 0;
      }
      
      private function __deputyWeaponChanged(param1:LivingEvent) : void
      {
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
      }
      
      private function __flyChanged(param1:LivingEvent) : void
      {
         if(!SavePointManager.Instance.savePoints[18])
         {
            return;
         }
         _cells[0].enabled = _self.flyEnabled;
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.FightModelBack");
         addChild(_background);
         super.configUI();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:Point = null;
         var _loc6_:ItemTemplateInfo = null;
         var _loc2_:WeaponPropCell = new WeaponPropCell("f",_mode);
         _loc2_.info = new PropInfo(ItemManager.Instance.getTemplateById(10016));
         _loc1_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosf");
         _loc2_.setPossiton(_loc1_.x,_loc1_.y);
         addChild(_loc2_);
         var _loc3_:WeaponPropCell = new WeaponPropCell("r",_mode);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosr");
         _loc3_.setPossiton(_loc1_.x,_loc1_.y);
         var _loc4_:WeaponPropCell = new WeaponPropCell("t",_mode);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPost");
         _loc4_.setPossiton(_loc1_.x,_loc1_.y);
         if(_self.hasDeputyWeapon())
         {
            _loc6_ = _self.currentDeputyWeaponInfo.Template;
            if(_loc6_.TemplateID == EquipType.WishKingBlessing)
            {
               _loc6_.Property4 = _self.wishKingEnergy.toString();
               _self.currentDeputyWeaponInfo.energy = _self.wishKingEnergy;
               _loc3_.info = new PropInfo(_loc6_);
            }
            else
            {
               _loc3_.info = new PropInfo(_loc6_);
            }
         }
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(17200);
         _loc4_.info = new PropInfo(_loc5_);
         _self.fightToolBoxCount = 1;
         _cells.push(_loc2_);
         _cells.push(_loc3_);
         _cells.push(_loc4_);
         super.drawCells();
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         _self.removeEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.removeEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         _self.removeEventListener(LivingEvent.WEAPONENABLED_CHANGE,this.__weaponEnabledChanged);
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.removeEvent();
      }
      
      public function setFlyVisible(param1:Boolean) : void
      {
         if(this._localFlyVisible != param1)
         {
            this._localFlyVisible = param1;
            if(this._localFlyVisible)
            {
               if(!_cells[0].parent)
               {
                  addChild(_cells[0]);
               }
            }
            else if(_cells[0].parent)
            {
               _cells[0].parent.removeChild(_cells[0]);
            }
         }
      }
      
      public function setDeputyWeaponVisible(param1:Boolean) : void
      {
         if(this._localDeputyWeaponVisible != param1)
         {
            this._localDeputyWeaponVisible = param1;
            if(this._localDeputyWeaponVisible)
            {
               if(!_cells[1].parent)
               {
                  addChild(_cells[1]);
               }
            }
            else if(_cells[1].parent)
            {
               _cells[1].parent.removeChild(_cells[1]);
            }
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this._localVisible = param1;
      }
   }
}
