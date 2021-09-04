package ddt.manager
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TimelineLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.TweenVars;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import game.view.GetGoodsTipView;
   import road7th.utils.MovieClipWrapper;
   import turnplate.TurnPlateController;
   
   public class DropGoodsManager implements Disposeable
   {
       
      
      public var parentContainer:DisplayObjectContainer;
      
      public var beginPoint:Point;
      
      public var endPoint:Point;
      
      private var goodsList:Vector.<ItemTemplateInfo>;
      
      private var timeOutIdArr:Array;
      
      private var tweenArr:Array;
      
      private var intervalId:uint;
      
      private var goodsTipList:Vector.<ItemTemplateInfo>;
      
      private var _info:InventoryItemInfo;
      
      public function DropGoodsManager(param1:Point, param2:Point)
      {
         super();
         this.parentContainer = StageReferance.stage;
         this.beginPoint = param1;
         this.endPoint = param2;
         this.goodsList = new Vector.<ItemTemplateInfo>();
         this.goodsTipList = new Vector.<ItemTemplateInfo>();
         this.timeOutIdArr = new Array();
         this.tweenArr = new Array();
      }
      
      public static function play(param1:Array, param2:Point = null, param3:Point = null) : void
      {
         var _loc6_:ItemTemplateInfo = null;
         var _loc7_:BaseCell = null;
         var _loc8_:uint = 0;
         if(param2 == null)
         {
            param2 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.beginPoint");
         }
         if(param3 == null)
         {
            param3 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.bagPoint");
         }
         var _loc4_:DropGoodsManager = new DropGoodsManager(param2,param3);
         _loc4_.setGoodsList(param1);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.goodsList.length)
         {
            _loc6_ = _loc4_.goodsList[_loc5_];
            _loc7_ = new BaseCell(new Sprite(),_loc6_);
            _loc7_.setContentSize(48,48);
            _loc8_ = setTimeout(_loc4_.packUp,200 + _loc5_ * 200,_loc7_,_loc4_.onCompletePackUp);
            _loc4_.timeOutIdArr.push(_loc8_);
            if(SavePointManager.Instance.savePoints[64])
            {
               if(_loc6_.CategoryID == 40 || EquipType.isPackage(_loc6_) || EquipType.canBeUsed(_loc6_))
               {
                  _loc4_.goodsTipList.push(_loc6_);
               }
            }
            _loc5_++;
         }
         if(BagAndInfoManager.Instance.IsClose)
         {
            _loc4_.intervalId = setInterval(_loc4_.showGetGoodTip,2000);
         }
      }
      
      public static function petPlay(param1:DisplayObject) : void
      {
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.beginPoint");
         var _loc3_:Point = ComponentFactory.Instance.creat("dropGoodsManager.petPoint");
         var _loc4_:DropGoodsManager = new DropGoodsManager(_loc2_,_loc3_);
         _loc4_.packUp(param1,_loc4_.onPetCompletePackUp);
      }
      
      public static function showTipByTemplateID(param1:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:EquipmentTemplateInfo = null;
         var _loc6_:GetGoodsTipView = null;
         if(TurnPlateController.Instance.isShow)
         {
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(param1);
         var _loc3_:InventoryItemInfo = _loc2_[0];
         if(_loc3_)
         {
            _loc4_ = false;
            if(_loc3_.CategoryID == 40)
            {
               _loc5_ = ItemManager.Instance.getEquipTemplateById(_loc3_.TemplateID);
               if(_loc5_.TemplateType != EquipType.EMBED_TYPE)
               {
                  _loc4_ = true;
               }
            }
            else if(EquipType.isPackage(_loc3_))
            {
               _loc4_ = true;
            }
            else if(EquipType.canBeUsed(_loc3_))
            {
               _loc4_ = true;
            }
            else if(!EquipType.isPetsEgg(_loc3_))
            {
               _loc4_ = true;
            }
            if(_loc4_)
            {
               _loc6_ = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTip");
               _loc6_.item = _loc3_;
               _loc6_.show();
            }
         }
      }
      
      private function onPetCompletePackUp(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(param1);
         this.dispose();
      }
      
      private function packUp(param1:DisplayObject, param2:Function) : void
      {
         clearTimeout(this.timeOutIdArr.shift());
         param1.x = this.beginPoint.x;
         param1.y = this.beginPoint.y;
         param1.alpha = 0.5;
         param1.scaleX = 0.85;
         param1.scaleY = 0.85;
         this.parentContainer.addChild(param1);
         var _loc3_:Point = this.endPoint;
         var _loc4_:Point = new Point(this.beginPoint.x - (this.beginPoint.x - _loc3_.x) / 2,this.beginPoint.y - 100);
         var _loc5_:Point = new Point(_loc4_.x - (_loc4_.x - this.beginPoint.x) / 2,this.beginPoint.y - 60);
         var _loc6_:Point = new Point(_loc3_.x - (_loc3_.x - _loc4_.x) / 2,this.beginPoint.y + 30);
         var _loc7_:TweenVars = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars1") as TweenVars;
         var _loc8_:TweenVars = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars2") as TweenVars;
         var _loc9_:TimelineLite = new TimelineLite();
         _loc9_.append(TweenMax.to(param1,_loc7_.duration,{
            "alpha":_loc7_.alpha,
            "scaleX":_loc7_.scaleX,
            "scaleY":_loc7_.scaleY,
            "bezierThrough":[{
               "x":_loc5_.x,
               "y":_loc5_.y
            },{
               "x":_loc4_.x,
               "y":_loc4_.y
            }],
            "ease":Sine.easeInOut
         }));
         _loc9_.append(TweenMax.to(param1,_loc8_.duration,{
            "alpha":_loc8_.alpha,
            "scaleX":_loc8_.scaleX,
            "scaleY":_loc8_.scaleY,
            "bezierThrough":[{
               "x":_loc6_.x,
               "y":_loc6_.y
            },{
               "x":_loc3_.x,
               "y":_loc3_.y
            }],
            "ease":Sine.easeInOut,
            "onComplete":param2,
            "onCompleteParams":[param1]
         }));
         this.tweenArr.push(_loc9_);
      }
      
      private function onCompletePackUp(param1:DisplayObject) : void
      {
         if(param1 && this.parentContainer.contains(param1))
         {
            ObjectUtils.disposeObject(param1);
            param1 = null;
         }
         var _loc2_:MovieClipWrapper = this.getBagAniam();
         if(_loc2_.movie)
         {
            this.parentContainer.addChild(_loc2_.movie);
         }
         SoundManager.instance.play("171");
         if(this.tweenArr.length > 0)
         {
            this.tweenArr.shift().clear();
         }
         else
         {
            this.dispose();
         }
      }
      
      private function getBagAniam() : MovieClipWrapper
      {
         var _loc2_:Point = null;
         var _loc1_:MovieClip = ClassUtils.CreatInstance("asset.game.bagAniam") as MovieClip;
         _loc2_ = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
         _loc1_.x = _loc2_.x;
         _loc1_.y = _loc2_.y;
         return new MovieClipWrapper(_loc1_,true,true);
      }
      
      private function setGoodsList(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(true)
            {
               if(_loc4_ >= this.goodsList.length)
               {
                  if(param1[_loc3_].TemplateID == EquipType.GOLD || param1[_loc3_].TemplateID == EquipType.STRENGTH_STONE1 || param1[_loc3_].TemplateID == EquipType.STRENGTH_STONE_NEW)
                  {
                     _loc7_ = Math.random() * 2 + 2;
                     _loc4_ = 0;
                     while(_loc4_ < _loc7_)
                     {
                        this.goodsList.push(param1[_loc3_]);
                        _loc4_++;
                     }
                     break;
                  }
                  _loc5_ = 0;
                  _loc6_ = new Object();
                  _loc4_ = 0;
                  while(_loc4_ < param1.length)
                  {
                     if(param1[_loc3_].TemplateID == param1[_loc4_].TemplateID)
                     {
                        _loc5_++;
                     }
                     _loc4_++;
                  }
                  _loc6_.item = param1[_loc3_];
                  _loc6_.count = _loc5_;
                  _loc2_.push(_loc6_);
                  break;
               }
               if(param1[_loc3_].TemplateID == this.goodsList[_loc4_].TemplateID)
               {
                  break;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         if(_loc2_.length > 7)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length && _loc3_ < 10)
            {
               this.goodsList.push(_loc2_[_loc3_].item);
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc8_ = _loc2_[_loc3_].count;
               if(_loc8_ == 1)
               {
                  this.goodsList.push(_loc2_[_loc3_].item);
               }
               else if(_loc8_ > 1 && _loc8_ <= 3)
               {
                  _loc7_ = Math.random() * 2 + 2;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     this.goodsList.push(_loc2_[_loc3_].item);
                     _loc9_++;
                  }
               }
               else if(_loc8_ > 3)
               {
                  _loc7_ = Math.random() * 3 + 2;
                  _loc9_ = 0;
                  while(_loc9_ < _loc7_)
                  {
                     this.goodsList.push(_loc2_[_loc3_].item);
                     _loc9_++;
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private function showGetGoodTip() : void
      {
         var _loc1_:ItemTemplateInfo = this.goodsTipList.pop();
         if(_loc1_ == null)
         {
            clearInterval(this.intervalId);
         }
         else
         {
            showTipByTemplateID(_loc1_.TemplateID);
         }
      }
      
      public function dispose() : void
      {
         this.parentContainer = null;
         this.beginPoint = null;
         this.endPoint = null;
         this.goodsList = null;
         this.timeOutIdArr = null;
         while(this.tweenArr.length > 0)
         {
            this.tweenArr.shift().clear();
         }
         this.tweenArr = null;
         this.goodsTipList = null;
         this._info = null;
      }
   }
}
