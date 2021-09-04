package totem.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class TotemLeftWindowView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _bgList:Vector.<Bitmap>;
      
      private var _totemPointSprite:Sprite;
      
      private var _totemPointList:Vector.<TotemLeftWindowTotemCell>;
      
      private var _curCanClickPointLocation:int;
      
      private var _totemPointLocationList:Array;
      
      private var _propertyTxtSprite:TotemLeftWindowPropertyTxtView;
      
      private var _tipView:TotemPointTipView;
      
      private var _routeMCs:Vector.<MovieClip>;
      
      private var _rountMCPoints:Vector.<Point>;
      
      private var _changePageFun:Function;
      
      private var _nextTotemInfo:TotemDataVo;
      
      private var openProcess:int = 0;
      
      private var _failTotemInfo:TotemDataVo;
      
      private var _currentPage:int;
      
      private var _openCount:int = 0;
      
      private var _nextPointInfo:TotemDataVo;
      
      private var _flowFrameCount:int = 0;
      
      private var _tmpLocation:int;
      
      public function TotemLeftWindowView()
      {
         this._totemPointLocationList = [[{
            "x":94,
            "y":62
         },{
            "x":164,
            "y":258
         },{
            "x":269,
            "y":111
         },{
            "x":365,
            "y":251
         },{
            "x":506,
            "y":189
         },{
            "x":663,
            "y":252
         },{
            "x":606,
            "y":86
         }],[{
            "x":57,
            "y":247
         },{
            "x":139,
            "y":63
         },{
            "x":269,
            "y":184
         },{
            "x":433,
            "y":97
         },{
            "x":622,
            "y":59
         },{
            "x":669,
            "y":233
         },{
            "x":434,
            "y":278
         }],[{
            "x":71,
            "y":197
         },{
            "x":176,
            "y":34
         },{
            "x":390,
            "y":74
         },{
            "x":245,
            "y":247
         },{
            "x":403,
            "y":204
         },{
            "x":524,
            "y":271
         },{
            "x":646,
            "y":137
         }],[{
            "x":100,
            "y":182
         },{
            "x":234,
            "y":80
         },{
            "x":291,
            "y":265
         },{
            "x":425,
            "y":124
         },{
            "x":535,
            "y":281
         },{
            "x":564,
            "y":122
         },{
            "x":686,
            "y":67
         }],[{
            "x":87,
            "y":27
         },{
            "x":120,
            "y":265
         },{
            "x":384,
            "y":277
         },{
            "x":596,
            "y":216
         },{
            "x":676,
            "y":62
         },{
            "x":489,
            "y":118
         },{
            "x":313,
            "y":68
         }]];
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         this._routeMCs = new Vector.<MovieClip>();
         this._rountMCPoints = new Vector.<Point>();
         this._bgList = new Vector.<Bitmap>();
         _loc1_ = 1;
         while(_loc1_ <= 5)
         {
            this._bgList.push(ComponentFactory.Instance.creatBitmap("asset.totem.leftView.windowBg" + _loc1_));
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ <= 5)
         {
            this._rountMCPoints.push(ComponentFactory.Instance.creatCustomObject("totem.flowpoint" + _loc1_));
            this._routeMCs.push(addChild(ClassUtils.CreatInstance("asset.totem.flow" + _loc1_)));
            DisplayUtils.setDisplayPos(this._routeMCs[_loc1_ - 1],this._rountMCPoints[_loc1_ - 1]);
            _loc1_++;
         }
         this._propertyTxtSprite = new TotemLeftWindowPropertyTxtView();
         this._tipView = new TotemPointTipView();
         this._tipView.visible = false;
         LayerManager.Instance.addToLayer(this._tipView,LayerManager.GAME_TOP_LAYER);
      }
      
      public function refreshView(param1:TotemDataVo, param2:Function = null) : void
      {
         this._tipView.visible = false;
         if(!TotemManager.instance.isLast)
         {
            this.refreshTotemPoint(param1.Page,param1,true);
         }
         else
         {
            this._changePageFun = param2;
            this._nextTotemInfo = param1;
            this.doLastLightFun();
         }
         TaskManager.instance.checkHighLight();
      }
      
      private function doLastLightFun() : void
      {
         TotemManager.instance.isLast = false;
         if(!this._nextTotemInfo)
         {
            this.doLastOpen(5);
            return;
         }
         this.doLastOpen(this._nextTotemInfo.Page);
         addEventListener(Event.ENTER_FRAME,this.__onOpenTotemProcess);
      }
      
      private function __onOpenTotemProcess(param1:Event) : void
      {
         var _loc2_:int = 0;
         ++this.openProcess;
         if(this.openProcess > 45)
         {
            this.refreshTotemPoint(this._nextTotemInfo.Page,this._nextTotemInfo,true);
            if(this._changePageFun != null)
            {
               this._changePageFun.apply();
            }
            this._routeMCs[this._nextTotemInfo.Page - 1].gotoAndPlay("stand2");
            this._totemPointList[0].isCurCanClick = true;
            this._totemPointList[0].isHasLighted = false;
            _loc2_ = 1;
            while(_loc2_ < 7)
            {
               this._totemPointList[_loc2_].isCurCanClick = false;
               this._totemPointList[_loc2_].isHasLighted = false;
               _loc2_++;
            }
            removeEventListener(Event.ENTER_FRAME,this.__onOpenTotemProcess);
            this.openProcess = 0;
         }
      }
      
      private function doLastOpen(param1:int = 1) : void
      {
         this._totemPointList[6].isCurCanClick = false;
         this._totemPointList[6].doLightTotem();
         var _loc2_:int = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId));
         this._propertyTxtSprite.refreshLayer(_loc2_,this._nextTotemInfo,param1);
      }
      
      public function openFailHandler(param1:TotemDataVo) : void
      {
         this._failTotemInfo = param1;
         this._totemPointList[param1.Location - 1].showOpenFail();
         TotemManager.instance.addEventListener(TotemLeftWindowTotemCell.OPEN_TOTEM_FAIL,this.__onFailMCcomplete);
      }
      
      private function __onFailMCcomplete(param1:Event) : void
      {
         this.refreshTotemPoint(this._failTotemInfo.Page,this._failTotemInfo,true);
      }
      
      private function enableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = true;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = true;
         }
      }
      
      private function disenableCurCanClickBtn() : void
      {
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].mouseChildren = false;
            this._totemPointList[this._curCanClickPointLocation - 1].mouseEnabled = false;
         }
      }
      
      public function show(param1:int, param2:TotemDataVo, param3:Boolean) : void
      {
         this.openProcess = 0;
         this._openCount = 0;
         this._flowFrameCount = 0;
         removeEventListener(Event.ENTER_FRAME,this.__onFlowStart);
         removeEventListener(Event.ENTER_FRAME,this.__onOpenTotemProcess);
         removeEventListener(Event.ENTER_FRAME,this.__onOpenComplete);
         if(param1 == 0)
         {
            param1 = 1;
         }
         if(this._bg)
         {
            removeChild(this._bg);
         }
         this._bg = this._bgList[param1 - 1];
         addChildAt(this._bg,0);
         var _loc4_:int = 1;
         while(_loc4_ <= 5)
         {
            if(param1 == _loc4_)
            {
               this._routeMCs[_loc4_ - 1].visible = true;
            }
            else
            {
               this._routeMCs[_loc4_ - 1].visible = false;
            }
            _loc4_++;
         }
         this.addTotemPoint(this._totemPointLocationList[param1 - 1],param1,param2,param3);
         addChild(this._propertyTxtSprite);
      }
      
      private function addTotemPoint(param1:Array, param2:int, param3:TotemDataVo, param4:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc7_:TotemLeftWindowTotemCell = null;
         var _loc8_:TotemLeftWindowTotemCell = null;
         if(this._totemPointSprite)
         {
            if(this._curCanClickPointLocation != 0 && this._totemPointList)
            {
               this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               this._curCanClickPointLocation = 0;
            }
            if(this._totemPointSprite.parent)
            {
               this._totemPointSprite.parent.removeChild(this._totemPointSprite);
            }
            this._totemPointSprite = null;
         }
         if(this._totemPointList)
         {
            for each(_loc7_ in this._totemPointList)
            {
               _loc7_.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               _loc7_.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(_loc7_);
            }
            this._totemPointList = null;
         }
         this._totemPointSprite = new Sprite();
         this._totemPointList = new Vector.<TotemLeftWindowTotemCell>();
         var _loc5_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = new TotemLeftWindowTotemCell(param2);
            _loc8_.x = param1[_loc6_].x;
            _loc8_.y = param1[_loc6_].y;
            _loc8_.addEventListener(MouseEvent.MOUSE_OVER,this.showTip,false,0,true);
            _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.hideTip,false,0,true);
            _loc8_.index = _loc6_ + 1;
            _loc8_.isCurCanClick = false;
            this._totemPointSprite.addChild(_loc8_);
            this._totemPointList.push(_loc8_);
            _loc6_++;
         }
         this._propertyTxtSprite.show(param1,param3,param2);
         this.refreshGlowFilter(param2,param3);
         this.refreshTotemPoint(param2,param3,param4);
         addChild(this._totemPointSprite);
      }
      
      private function refreshGlowFilter(param1:int, param2:TotemDataVo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = this._totemPointList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(!param2 || param1 < param2.Page || _loc3_ + 1 < param2.Location)
            {
               if(!TotemManager.instance.isUpgrade)
               {
                  this._totemPointList[_loc3_].isHasLighted = true;
               }
               else
               {
                  this._totemPointList[_loc3_].doLightTotem();
               }
            }
            else
            {
               this._totemPointList[_loc3_].isHasLighted = false;
            }
            _loc3_++;
         }
      }
      
      private function refreshTotemPoint(param1:int, param2:TotemDataVo, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         if(param2 && param1 == param2.Page)
         {
            if(TotemManager.instance.isUpgrade && param2.Location != 1)
            {
               this._currentPage = param1;
               this._nextPointInfo = param2;
               addEventListener(Event.ENTER_FRAME,this.__onFlowStart);
            }
            else if(this._routeMCs && param2.Location != 7)
            {
               this._routeMCs[param1 - 1].gotoAndPlay("stand" + (param2.Location + 1) + "1");
            }
            else
            {
               this._routeMCs[param1 - 1].gotoAndStop("stand9");
            }
         }
         else
         {
            this._routeMCs[param1 - 1].gotoAndStop("stand9");
         }
         if(this._curCanClickPointLocation != 0)
         {
            _loc7_ = this._curCanClickPointLocation - 1;
            this._totemPointList[_loc7_].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._totemPointList[_loc7_].useHandCursor = false;
            this._totemPointList[_loc7_].buttonMode = false;
            this._totemPointList[_loc7_].mouseChildren = true;
            this._totemPointList[_loc7_].mouseEnabled = true;
            this._totemPointList[_loc7_].isCurCanClick = false;
            if(!TotemManager.instance.isUpgrade)
            {
               this._totemPointList[_loc7_].isHasLighted = true;
               TotemManager.instance.isUpgrade = false;
            }
            else
            {
               this._totemPointList[_loc7_].doLightTotem();
            }
            this._curCanClickPointLocation = 0;
         }
         if(param3 && param2 && param1 == param2.Page)
         {
            this._tmpLocation = param2.Location - 1;
            this._curCanClickPointLocation = param2.Location;
            if(!TotemManager.instance.isUpgrade || param2.Location == 1)
            {
               this.setTotemClickable(this._tmpLocation);
            }
         }
         if(!param2 || param1 < param2.Page)
         {
            _loc4_ = param1 * 10;
         }
         else
         {
            _loc4_ = (param1 - 1) * 10 + param2.Layers;
         }
         this._propertyTxtSprite.refreshLayer(_loc4_,param2,param1);
         var _loc5_:int = this._totemPointList.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            this._totemPointList[_loc6_].level = _loc4_;
            _loc6_++;
         }
         if(param1 == 1)
         {
            this.showUserGuilde();
         }
      }
      
      private function __onFlowStart(param1:Event) : void
      {
         ++this._openCount;
         if(this._openCount >= 35)
         {
            this._routeMCs[this._currentPage - 1].gotoAndPlay("stand" + (this._nextPointInfo.Location + 1));
            removeEventListener(Event.ENTER_FRAME,this.__onFlowStart);
            this._openCount = 0;
            addEventListener(Event.ENTER_FRAME,this.__onOpenComplete);
         }
      }
      
      private function setTotemClickable(param1:int) : void
      {
         this._totemPointList[this._tmpLocation].useHandCursor = true;
         this._totemPointList[this._tmpLocation].buttonMode = true;
         this._totemPointList[this._tmpLocation].mouseChildren = true;
         this._totemPointList[this._tmpLocation].mouseEnabled = true;
         this._totemPointList[this._tmpLocation].addEventListener(MouseEvent.CLICK,this.openTotem,false,0,true);
         this._totemPointList[this._tmpLocation].isCurCanClick = true;
      }
      
      private function __onOpenComplete(param1:Event) : void
      {
         ++this._flowFrameCount;
         if(this._flowFrameCount >= 20)
         {
            this.setTotemClickable(this._tmpLocation);
            removeEventListener(Event.ENTER_FRAME,this.__onOpenComplete);
            this._flowFrameCount = 0;
         }
      }
      
      public function scalePropertyTxtSprite(param1:Number) : void
      {
         if(this._propertyTxtSprite)
         {
            this._propertyTxtSprite.scaleTxt(param1);
         }
      }
      
      private function openTotem(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
         if(PlayerManager.Instance.Self.totemScores < _loc2_.ConsumeHonor || TotemManager.instance.usableGP < _loc2_.ConsumeExp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorOrExpUnenough"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < _loc2_.needGrade)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.needGrade",_loc2_.needGrade));
            return;
         }
         this.disenableCurCanClickBtn();
         SocketManager.Instance.out.sendOpenOneTotem();
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         var _loc2_:TotemLeftWindowTotemCell = null;
         var _loc3_:Point = null;
         _loc2_ = param1.currentTarget as TotemLeftWindowTotemCell;
         if(!_loc2_.isCurCanClick)
         {
            return;
         }
         _loc3_ = this.localToGlobal(new Point(_loc2_.x + _loc2_.width / 2 + 30,_loc2_.y - 30));
         this._tipView.x = _loc3_.x;
         this._tipView.y = _loc3_.y;
         var _loc4_:TotemDataVo = TotemManager.instance.getCurInfoByLevel((_loc2_.level - 1) * 7 + _loc2_.index);
         this._tipView.show(_loc4_,_loc2_.isCurCanClick,_loc2_.isHasLighted);
         this._tipView.visible = true;
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         this._tipView.visible = false;
      }
      
      public function showUserGuilde() : void
      {
         if(!SavePointManager.Instance.savePoints[69] && !TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(593)) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(592)))
         {
            if(this._curCanClickPointLocation == 1)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,-90,"trainer.totemClick1","","",this);
            }
            if(this._curCanClickPointLocation == 2)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,-135,"trainer.totemClick2","","",this);
            }
            if(this._curCanClickPointLocation == 3)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,0,"trainer.totemClick3","","",this);
            }
            if(this._curCanClickPointLocation == 4)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,-90,"trainer.totemClick4","","",this);
            }
            if(this._curCanClickPointLocation == 5)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,0,"trainer.totemClick5","","",this);
            }
            if(this._curCanClickPointLocation == 6)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,-90,"trainer.totemClick6","","",this);
            }
            if(this._curCanClickPointLocation == 7)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM,-90,"trainer.totemClick7","","",this);
            }
         }
         else
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:TotemLeftWindowTotemCell = null;
         removeEventListener(Event.ENTER_FRAME,this.__onFlowStart);
         removeEventListener(Event.ENTER_FRAME,this.__onOpenTotemProcess);
         removeEventListener(Event.ENTER_FRAME,this.__onOpenComplete);
         TotemManager.instance.removeEventListener(TotemLeftWindowTotemCell.OPEN_TOTEM_FAIL,this.__onFailMCcomplete);
         if(this._curCanClickPointLocation != 0 && this._totemPointList)
         {
            this._totemPointList[this._curCanClickPointLocation - 1].useHandCursor = false;
            this._totemPointList[this._curCanClickPointLocation - 1].removeEventListener(MouseEvent.CLICK,this.openTotem);
            this._curCanClickPointLocation = 0;
         }
         if(this._totemPointList)
         {
            for each(_loc1_ in this._totemPointList)
            {
               _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.showTip);
               _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.hideTip);
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         ObjectUtils.disposeAllChildren(this);
         this._totemPointSprite = null;
         this._totemPointList = null;
         this._bg = null;
         this._bgList = null;
         this._propertyTxtSprite = null;
         this._routeMCs = null;
         ObjectUtils.disposeObject(this._tipView);
         this._tipView = null;
         TotemManager.instance.isUpgrade = false;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
