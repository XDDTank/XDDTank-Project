package militaryrank.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class RankView extends Sprite implements Disposeable
   {
       
      
      private var _bg:MutipleImage;
      
      private var _junxianBitm:Bitmap;
      
      private var _zhanjiBitm:Bitmap;
      
      private var _scroll:ScrollPanel;
      
      private var _list:VBox;
      
      private var _items:Vector.<RankOrderItem>;
      
      public function RankView()
      {
         super();
         this.initView();
         this.initItems();
      }
      
      private function initView() : void
      {
         this._items = new Vector.<RankOrderItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("militaryrank.right.listBg");
         addChild(this._bg);
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("militaryrank.listTitleText");
         PositionUtils.setPos(_loc1_,"militaryrank.junxianText.pos");
         _loc1_.text = "军衔";
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("militaryrank.listTitleText");
         PositionUtils.setPos(_loc2_,"militaryrank.zhanjiText.pos");
         _loc2_.text = "战绩";
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         PositionUtils.setPos(_loc3_,"militaryrank.line.pos1");
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(_loc3_);
         this._list = ComponentFactory.Instance.creatComponentByStylename("Military.vboxContainer");
         addChild(this._list);
         this._scroll = ComponentFactory.Instance.creat("militaryrank.Info.RankScroll");
         addChild(this._scroll);
      }
      
      private function initItems() : void
      {
         var _loc7_:RankOrderItem = null;
         var _loc1_:RankOrderItem = new RankOrderItem(0);
         _loc1_.info = -1;
         this._list.addChild(_loc1_);
         this._items.push(_loc1_);
         var _loc2_:RankOrderItem = new RankOrderItem(1);
         _loc2_.info = -2;
         this._list.addChild(_loc2_);
         this._items.push(_loc2_);
         var _loc3_:RankOrderItem = new RankOrderItem(0);
         _loc3_.info = -3;
         this._list.addChild(_loc3_);
         this._items.push(_loc3_);
         var _loc4_:int = ServerConfigManager.instance.getMilitaryData().length;
         var _loc5_:Array = ServerConfigManager.instance.getMilitaryData();
         var _loc6_:int = _loc4_ - 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = new RankOrderItem(_loc6_ + 1);
            _loc7_.info = _loc5_[_loc6_];
            this._list.addChild(_loc7_);
            this._items.push(_loc7_);
            _loc6_--;
         }
         this._scroll.setView(this._list);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._junxianBitm = null;
         this._zhanjiBitm = null;
         this._scroll = null;
         this._list = null;
         this._items = null;
      }
   }
}
