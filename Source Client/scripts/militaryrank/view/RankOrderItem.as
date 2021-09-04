package militaryrank.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import militaryrank.MilitaryRankManager;
   import militaryrank.model.MilitaryLevelModel;
   
   public class RankOrderItem extends Sprite implements Disposeable
   {
       
      
      private var _itemBG:ScaleFrameImage;
      
      private var _vline:Bitmap;
      
      private var _index:int;
      
      private var _info:ConsortiaInfo;
      
      private var _selected:Boolean;
      
      private var _militaryDataTxt:FilterFrameText;
      
      private var _militaryNameTxt:FilterFrameText;
      
      private var _icon:MilitaryIcon;
      
      private var _array:Array;
      
      public function RankOrderItem(param1:int)
      {
         super();
         this._index = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("militaryrank.MemberListItem");
         if(this._index % 2 == 0)
         {
            this._itemBG.setFrame(2);
         }
         else
         {
            this._itemBG.setFrame(1);
         }
         this._vline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
         PositionUtils.setPos(this._vline,"militaryrank.line.pos");
         this._militaryDataTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.dataTxt");
         this._militaryNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.nameTxt");
         this._icon = new MilitaryIcon(new PlayerInfo());
         this._icon.ShowTips = false;
         PositionUtils.setPos(this._icon,"militaryrank.Icon.pos");
         addChild(this._itemBG);
         this._vline.height = 22;
         addChild(this._vline);
         addChild(this._icon);
         addChild(this._militaryDataTxt);
         addChild(this._militaryNameTxt);
         this._array = LanguageMgr.GetTranslation("militaryrank.view.zhanjiList").split(",");
      }
      
      public function set info(param1:int) : void
      {
         var _loc2_:MilitaryLevelModel = null;
         if(param1 == -1)
         {
            this._icon.setCusFrame(16);
            this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[15];
            this._militaryDataTxt.text = this._array[2];
         }
         else if(param1 == -2)
         {
            this._icon.setCusFrame(15);
            this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[14];
            this._militaryDataTxt.text = this._array[1];
         }
         else if(param1 == -3)
         {
            this._icon.setCusFrame(14);
            this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[13];
            this._militaryDataTxt.text = this._array[0];
         }
         else
         {
            this._icon.setMilitary(param1);
            _loc2_ = MilitaryRankManager.Instance.getMilitaryRankInfo(param1);
            this._militaryNameTxt.text = _loc2_.Name;
            this._militaryDataTxt.text = _loc2_.MaxScore == int.MAX_VALUE ? _loc2_.MinScore + "～" : _loc2_.MinScore + "～" + (_loc2_.MaxScore - 1);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set light(param1:Boolean) : void
      {
         if(this._selected)
         {
            return;
         }
      }
      
      override public function get height() : Number
      {
         if(this._itemBG == null)
         {
            return 0;
         }
         return this._itemBG.y + this._itemBG.height;
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(param1:*) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set isApply(param1:Boolean) : void
      {
         if(param1)
         {
            alpha = 0.5;
            mouseChildren = false;
            mouseEnabled = false;
         }
         else
         {
            alpha = 1;
            mouseChildren = true;
            mouseEnabled = true;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._itemBG = null;
         this._vline = null;
         this._militaryDataTxt = null;
         this._militaryNameTxt = null;
         this._icon = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
