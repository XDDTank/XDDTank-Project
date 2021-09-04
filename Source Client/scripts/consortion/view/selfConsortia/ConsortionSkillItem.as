package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionNewSkillInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class ConsortionSkillItem extends Sprite implements Disposeable
   {
       
      
      private var _bg1:Bitmap;
      
      private var _bg2:ScaleBitmapImage;
      
      private var _cellBG1:DisplayObject;
      
      private var _cellBG2:DisplayObject;
      
      private var _sign:Bitmap;
      
      private var _level:int;
      
      private var _open:Boolean;
      
      private var _isMetal:Boolean;
      
      private var _cells:Vector.<ConsortionSkillCell>;
      
      private var _cellsBg:Vector.<Bitmap>;
      
      private var _currentInfo:ConsortionNewSkillInfo;
      
      private var _upgradeBtns:Vector.<BaseButton>;
      
      private var _shine:MovieClip;
      
      public function ConsortionSkillItem(param1:int, param2:Boolean, param3:Boolean = false)
      {
         super();
         this._level = param1;
         this._open = param2;
         this._isMetal = param3;
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatBitmap("skillFrame.ItemBG1");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("skillFrame.ItemBG2");
         this._cellBG1 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG1");
         this._cellBG2 = ComponentFactory.Instance.creatCustomObject("skillFrame.ItemCellBG2");
         this._sign = ComponentFactory.Instance.creatBitmap("consortion.skillFrame.grade_" + this._level);
         PositionUtils.setPos(this._sign,"consortion.skillFrame.gradePos");
         addChild(this._bg1);
         addChild(this._sign);
         if(!this._open)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
         this._cells = new Vector.<ConsortionSkillCell>();
         this._cellsBg = new Vector.<Bitmap>();
         this._upgradeBtns = new Vector.<BaseButton>();
      }
      
      public function set data(param1:Vector.<ConsortionNewSkillInfo>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:ConsortionSkillCell = null;
         var _loc5_:BaseButton = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.consortion.SkillBg");
            _loc3_.x = 132 + _loc3_.width * _loc2_;
            _loc3_.y = 6;
            addChild(_loc3_);
            this._cellsBg.push(_loc3_);
            _loc4_ = new ConsortionSkillCell();
            _loc4_.info = param1[_loc2_];
            _loc4_.x = 147 + _loc3_.width * _loc2_;
            _loc4_.y = 13;
            addChild(_loc4_);
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.SkillUpgradeBtn");
            addChild(_loc5_);
            _loc5_.x = 170 + 72 * _loc2_;
            _loc5_.y = 42;
            this._upgradeBtns.push(_loc5_);
            this._upgradeBtns[_loc2_].addEventListener(MouseEvent.CLICK,this.__upgrade);
            this._cells.push(_loc4_);
            if(!this._open)
            {
               this._cells[_loc2_].isLearn(false);
               this._upgradeBtns[_loc2_].visible = false;
            }
            else if(ConsortionModelControl.Instance.model.getisLearnByBuffId(param1[_loc2_].BuffID))
            {
               this._upgradeBtns[_loc2_].visible = false;
               this._cells[_loc2_].isLearn(true);
            }
            else if(ConsortionModelControl.Instance.model.getisUpgradeByBuffId(param1[_loc2_].BuffID))
            {
               this._upgradeBtns[_loc2_].visible = false;
               this._cells[_loc2_].isLearn(true);
            }
            else if(param1[_loc2_].BuffID != 1 && !ConsortionModelControl.Instance.model.getisLearnByBuffId(param1[_loc2_].BuffID - 1))
            {
               this._upgradeBtns[_loc2_].visible = false;
               this._cells[_loc2_].isLearn(false);
            }
            else
            {
               this._upgradeBtns[_loc2_].visible = true;
               this._cells[_loc2_].isLearn(false);
            }
            _loc2_++;
         }
         this.setStatus();
      }
      
      private function setStatus() : void
      {
         var _loc1_:DictionaryData = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = PlayerManager.Instance.Self.isLearnSkill;
         _loc2_ = 0;
         while(_loc2_ < this._cells.length)
         {
            _loc3_ = PlayerManager.Instance.Self.isLearnSkill.length;
            if(this._cells[_loc2_].info)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  if(this._cells[_loc2_].info.BuffID == int(_loc1_[_loc4_]))
                  {
                     this._upgradeBtns[_loc2_].visible = false;
                     if(_loc4_ + 1 == _loc3_ && this._cells[_loc2_].info.BuffID == int(_loc1_[_loc4_]) && ConsortionModelControl.Instance.model.shinePlay)
                     {
                        if(!this._shine)
                        {
                           this._shine = ComponentFactory.Instance.creat("consortion.SkillView.skillItem.shine");
                           addChild(this._shine);
                           this._shine.x = this._cells[_loc2_].x - 12;
                           this._shine.y = 4;
                           this._shine.mouseChildren = false;
                           this._shine.mouseEnabled = false;
                        }
                        this._shine.play();
                        ConsortionModelControl.Instance.model.shinePlay = false;
                     }
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
      }
      
      private function __upgrade(param1:MouseEvent) : void
      {
         this._currentInfo = this._cells[this._upgradeBtns.indexOf(param1.currentTarget as BaseButton)].info;
         SocketManager.Instance.out.sendConsortionSkill(this._currentInfo.BuffID);
      }
      
      override public function get height() : Number
      {
         return this._bg1.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            this._cells[_loc1_] = null;
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._upgradeBtns.length)
         {
            this._upgradeBtns[_loc1_] = null;
            _loc2_++;
         }
         this._bg1 = null;
         this._bg2 = null;
         this._cellBG1 = null;
         this._cellBG2 = null;
         this._sign = null;
         this._cells = null;
         this._upgradeBtns = null;
         this._shine = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
