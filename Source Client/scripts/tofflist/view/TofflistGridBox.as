package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import tofflist.data.TofflistLayoutInfo;
   
   public class TofflistGridBox extends Sprite implements Disposeable
   {
      
      private static const RANK:String = LanguageMgr.GetTranslation("repute");
      
      private static const NAME:String = LanguageMgr.GetTranslation("civil.rightview.listname");
      
      private static const BATTLE:String = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
      
      private static const LEVEL:String = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
      
      private static const EXP:String = LanguageMgr.GetTranslation("exp");
      
      private static const SCORE:String = LanguageMgr.GetTranslation("tofflist.score");
      
      private static const ACHIVE_POINT:String = LanguageMgr.GetTranslation("tofflist.achivepoint");
      
      private static const ASSET:String = LanguageMgr.GetTranslation("tank.fightLib.FightLibAwardView.exp");
      
      private static const TOTAL_ASSET:String = LanguageMgr.GetTranslation("tofflist.totalasset");
      
      private static const SERVER:String = LanguageMgr.GetTranslation("tofflist.server");
      
      private static const MILITARY_SCORE:String = LanguageMgr.GetTranslation("tank.menu.MilitaryTxt");
      
      private static const MILITARY:String = LanguageMgr.GetTranslation("tank.menu.MilitaryScore");
      
      private static const ARENA_SCORE_TANK:String = LanguageMgr.GetTranslation("tofflist.arenaScoreTank");
      
      private static const ARENA_SCORE:String = LanguageMgr.GetTranslation("tofflist.arenaScore");
       
      
      private var _bg:MutipleImage;
      
      private var _titleBg:MutipleImage;
      
      private var _layoutInfoArr:Dictionary;
      
      private var _title:Sprite;
      
      private var _scoreBtnShine:Bitmap;
      
      private var _winBtnShine:Bitmap;
      
      private var _arenaGroup:SelectedButtonGroup;
      
      private var _orderList:TofflistOrderList;
      
      private var _id:String;
      
      private var _arenaID:String;
      
      public function TofflistGridBox()
      {
         super();
         this._layoutInfoArr = new Dictionary();
         this.initData();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.right.listBg");
         addChild(this._bg);
         this._title = new Sprite();
         addChild(this._title);
         this._orderList = new TofflistOrderList();
         PositionUtils.setPos(this._orderList,"tofflist.orderlistPos");
         addChild(this._orderList);
      }
      
      private function initData() : void
      {
         var _loc1_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_battle");
         _loc1_.TitleTextString = [RANK,NAME,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_BATTLE] = _loc1_;
         var _loc2_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_level");
         _loc2_.TitleTextString = [RANK,NAME,LEVEL,EXP];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_LEVEL] = _loc2_;
         var _loc3_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_military");
         _loc3_.TitleTextString = [RANK,NAME,MILITARY,MILITARY_SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MILITARY] = _loc3_;
         var _loc4_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_achive");
         _loc4_.TitleTextString = [RANK,NAME,ACHIVE_POINT];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_ACHIVE] = _loc4_;
         var _loc5_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_match");
         _loc5_.TitleTextString = [RANK,NAME,SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MATCH] = _loc5_;
         var _loc6_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_arena_score");
         _loc6_.TitleTextString = [ARENA_SCORE_TANK,NAME,ARENA_SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY] = _loc6_;
         var _loc7_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_battle");
         _loc7_.TitleTextString = [RANK,NAME,SERVER,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_BATTLE] = _loc7_;
         var _loc8_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_level");
         _loc8_.TitleTextString = [RANK,NAME,LEVEL,SERVER,EXP];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_LEVEL] = _loc8_;
         var _loc9_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_achive");
         _loc9_.TitleTextString = [RANK,NAME,SERVER,ACHIVE_POINT];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_ACHIVE] = _loc9_;
         var _loc10_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_arena_score");
         _loc10_.TitleTextString = [ARENA_SCORE_TANK,NAME,SERVER,ARENA_SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.CROSS_ARENA_SCORE_DAY] = _loc10_;
         var _loc11_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_battle");
         _loc11_.TitleTextString = [RANK,NAME,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_BATTLE] = _loc11_;
         var _loc12_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_level");
         _loc12_.TitleTextString = [RANK,NAME,LEVEL,ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_LEVEL] = _loc12_;
         var _loc13_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_asset");
         _loc13_.TitleTextString = [RANK,NAME,TOTAL_ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_ASSET] = _loc13_;
         var _loc14_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_battle");
         _loc14_.TitleTextString = [RANK,NAME,SERVER,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_BATTLE] = _loc14_;
         var _loc15_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_level");
         _loc15_.TitleTextString = [RANK,NAME,LEVEL,SERVER,ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_LEVEL] = _loc15_;
         var _loc16_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_asset");
         _loc16_.TitleTextString = [RANK,NAME,SERVER,TOTAL_ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_ASSET] = _loc16_;
         var _loc17_:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("local_arena_score");
         _loc17_.TitleTextString = [RANK,NAME,ARENA_SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.LOCAL_ARENA_SCORE_DAY] = _loc17_;
      }
      
      public function get orderList() : TofflistOrderList
      {
         return this._orderList;
      }
      
      public function updateList(param1:Array, param2:int = 1) : void
      {
         var _loc3_:TofflistLayoutInfo = null;
         this._orderList.items(param1,param2);
         if(this._id)
         {
            _loc3_ = this._layoutInfoArr[this._id];
            this._orderList.showHline(_loc3_.TitleHLinePoint);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._arenaGroup)
         {
            this._arenaGroup.removeEventListener(Event.CHANGE,this.__arenaGroupChange);
         }
         ObjectUtils.disposeObject(this._arenaGroup);
         this._arenaGroup = null;
         while(numChildren > 1)
         {
            _loc1_ = getChildAt(0);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
      }
      
      public function updateStyleXY(param1:String) : void
      {
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:FilterFrameText = null;
         this._id = param1;
         ObjectUtils.disposeAllChildren(this._title);
         var _loc2_:TofflistLayoutInfo = this._layoutInfoArr[this._id];
         for each(_loc3_ in _loc2_.TitleHLinePoint)
         {
            _loc5_ = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            PositionUtils.setPos(_loc5_,_loc3_);
            this._title.addChild(_loc5_);
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.TitleTextPoint.length)
         {
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("toffilist.listTitleText");
            PositionUtils.setPos(_loc6_,_loc2_.TitleTextPoint[_loc4_]);
            _loc6_.text = _loc2_.TitleTextString[_loc4_];
            this._title.addChild(_loc6_);
            _loc4_++;
         }
      }
      
      private function __arenaGroupChange(param1:Event) : void
      {
         this.updateStyleXY(this._arenaID);
      }
   }
}
