package platformapi.tencent.view
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import platformapi.tencent.DiamondManager;
   
   public class MemberDiamondGiftItem extends Sprite implements Disposeable
   {
       
      
      private var cellSize:int = 36;
      
      private var _icon:DiamondIcon;
      
      private var _daytext:FilterFrameText;
      
      private var _cellNum:FilterFrameText;
      
      private var _cellNumII:FilterFrameText;
      
      private var _cell:PersonalInfoCell;
      
      private var _cellII:PersonalInfoCell;
      
      private var _line:Bitmap;
      
      private var _light:Bitmap;
      
      private var _level:int;
      
      public function MemberDiamondGiftItem(param1:int)
      {
         super();
         this._level = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._icon = new DiamondIcon(0);
         PositionUtils.setPos(this._icon,"memberDiamondGift.view.MemberDiamondGiftItem.diamondIconPos");
         addChild(this._icon);
         this._daytext = UICreatShortcut.creatTextAndAdd("memberDiamondGift.view.dayText",LanguageMgr.GetTranslation("memberDiamondGift.view.day"),this);
         this._cellNum = UICreatShortcut.creatAndAdd("memberDiamondGift.view.numText",this);
         this._cellNumII = UICreatShortcut.creatAndAdd("memberDiamondGift.view.numIIText",this);
         this._line = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.smallDiamond",this);
         this._cell = PersonalInfoCell(CellFactory.instance.createPersonalInfoCell(0));
         PositionUtils.setPos(this._cell,"memberDiamondGift.view.MemberDiamondGiftItem.cellPos");
         this._cell.setContentSize(this.cellSize,this.cellSize);
         addChild(this._cell);
         this._cellII = PersonalInfoCell(CellFactory.instance.createPersonalInfoCell(0));
         PositionUtils.setPos(this._cellII,"memberDiamondGift.view.MemberDiamondGiftItem.cellIIPos");
         this._cellII.setContentSize(this.cellSize,this.cellSize);
         addChild(this._cellII);
         this._light = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.Blue.light");
         this._light.visible = false;
         addChild(this._light);
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:Array = null;
         _loc1_ = DiamondManager.instance.model.awardList[this._level];
         if(_loc1_[0])
         {
            this._cellNum.visible = this._cell.visible = true;
            this._cellNum.text = "x" + (_loc1_[0] as DaylyGiveInfo).Count.toString();
            this._cell.info = ItemManager.Instance.getTemplateById((_loc1_[0] as DaylyGiveInfo).TemplateID);
         }
         else
         {
            this._cellNum.visible = this._cell.visible = false;
         }
         if(_loc1_[1])
         {
            this._cellII.visible = this._cellNumII.visible = true;
            this._cellII.info = ItemManager.Instance.getTemplateById((_loc1_[1] as DaylyGiveInfo).TemplateID);
            this._cellNumII.text = "x" + (_loc1_[1] as DaylyGiveInfo).Count.toString();
         }
         else
         {
            this._cellII.visible = this._cellNumII.visible = false;
         }
         this._icon.level = this._level;
         this._light.visible = this._level == PlayerManager.Instance.Self.MemberDiamondLevel;
      }
      
      override public function get height() : Number
      {
         return 42;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._daytext);
         this._daytext = null;
         ObjectUtils.disposeObject(this._cellNum);
         this._cellNum = null;
         ObjectUtils.disposeObject(this._cellNumII);
         this._cellNumII = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._cellII);
         this._cellII = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         ObjectUtils.disposeObject(this._light);
         this._light = null;
      }
   }
}