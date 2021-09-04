package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PetInfoManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import pet.date.PetInfo;
   
   public class PetTransformPropertyItem extends Component
   {
       
      
      private var _bloodLabel:FilterFrameText;
      
      private var _attackLabel:FilterFrameText;
      
      private var _defenceLabel:FilterFrameText;
      
      private var _agilityLabel:FilterFrameText;
      
      private var _luckLabel:FilterFrameText;
      
      private var _leftTxtBefore:FilterFrameText;
      
      private var _leftTxtAfter:FilterFrameText;
      
      private var _rightTxtBefore:FilterFrameText;
      
      private var _rightTxtAfter:FilterFrameText;
      
      private var _upflagLeft:Bitmap;
      
      private var _dowmArrowLeft:Bitmap;
      
      private var _upflagRight:Bitmap;
      
      private var _dowmArrowRight:Bitmap;
      
      private var _type:int;
      
      private var _leftInfoBefore:PetInfo;
      
      private var _leftInfoAfter:PetInfo;
      
      private var _rightInfoBefore:PetInfo;
      
      private var _rightInfoAfter:PetInfo;
      
      public function PetTransformPropertyItem(param1:int)
      {
         this._type = param1;
         super();
      }
      
      public function setInfo(param1:PetInfo, param2:PetInfo) : void
      {
         this._leftInfoBefore = param1;
         this._rightInfoBefore = param2;
         this._leftInfoAfter = PetInfoManager.instance.getTransformPet(this._leftInfoBefore,this._rightInfoBefore);
         this._rightInfoAfter = PetInfoManager.instance.getTransformPet(this._rightInfoBefore,this._leftInfoBefore);
         this._leftTxtBefore.text = "";
         this._leftTxtAfter.text = "";
         this._rightTxtBefore.text = "";
         this._rightTxtAfter.text = "";
         switch(this._type)
         {
            case 0:
               if(this._leftInfoBefore)
               {
                  this._leftTxtBefore.text = int(this._leftInfoBefore.Blood / 100).toString();
               }
               if(this._rightInfoBefore)
               {
                  this._rightTxtBefore.text = int(this._rightInfoBefore.Blood / 100).toString();
               }
               if(this._leftInfoBefore && this._rightInfoBefore)
               {
                  this._leftTxtAfter.text = int(this._leftInfoAfter.Blood / 100).toString();
                  this._rightTxtAfter.text = int(this._rightInfoAfter.Blood / 100).toString();
               }
               break;
            case 1:
               if(this._leftInfoBefore)
               {
                  this._leftTxtBefore.text = int(this._leftInfoBefore.Attack / 100).toString();
               }
               if(this._rightInfoBefore)
               {
                  this._rightTxtBefore.text = int(this._rightInfoBefore.Attack / 100).toString();
               }
               if(this._leftInfoBefore && this._rightInfoBefore)
               {
                  this._leftTxtAfter.text = int(this._leftInfoAfter.Attack / 100).toString();
                  this._rightTxtAfter.text = int(this._rightInfoAfter.Attack / 100).toString();
               }
               break;
            case 2:
               if(this._leftInfoBefore)
               {
                  this._leftTxtBefore.text = int(this._leftInfoBefore.Defence / 100).toString();
               }
               if(this._rightInfoBefore)
               {
                  this._rightTxtBefore.text = int(this._rightInfoBefore.Defence / 100).toString();
               }
               if(this._leftInfoBefore && this._rightInfoBefore)
               {
                  this._leftTxtAfter.text = int(this._leftInfoAfter.Defence / 100).toString();
                  this._rightTxtAfter.text = int(this._rightInfoAfter.Defence / 100).toString();
               }
               break;
            case 3:
               if(this._leftInfoBefore)
               {
                  this._leftTxtBefore.text = int(this._leftInfoBefore.Agility / 100).toString();
               }
               if(this._rightInfoBefore)
               {
                  this._rightTxtBefore.text = int(this._rightInfoBefore.Agility / 100).toString();
               }
               if(this._leftInfoBefore && this._rightInfoBefore)
               {
                  this._leftTxtAfter.text = int(this._leftInfoAfter.Agility / 100).toString();
                  this._rightTxtAfter.text = int(this._rightInfoAfter.Agility / 100).toString();
               }
               break;
            case 4:
               if(this._leftInfoBefore)
               {
                  this._leftTxtBefore.text = int(this._leftInfoBefore.Luck / 100).toString();
               }
               if(this._rightInfoBefore)
               {
                  this._rightTxtBefore.text = int(this._rightInfoBefore.Luck / 100).toString();
               }
               if(this._leftInfoBefore && this._rightInfoBefore)
               {
                  this._leftTxtAfter.text = int(this._leftInfoAfter.Luck / 100).toString();
                  this._rightTxtAfter.text = int(this._rightInfoAfter.Luck / 100).toString();
               }
         }
         if(this._leftTxtBefore.text != "" && this._leftTxtAfter.text != "")
         {
            if(int(this._leftTxtBefore.text) > int(this._leftTxtAfter.text))
            {
               this._upflagLeft.visible = false;
               this._dowmArrowLeft.visible = true;
            }
            else if(int(this._leftTxtBefore.text) < int(this._leftTxtAfter.text))
            {
               this._upflagLeft.visible = true;
               this._dowmArrowLeft.visible = false;
            }
         }
         else
         {
            this._upflagLeft.visible = false;
            this._dowmArrowLeft.visible = false;
         }
         if(this._rightTxtBefore.text != "" && this._rightTxtAfter.text != "")
         {
            if(int(this._rightTxtBefore.text) > int(this._rightTxtAfter.text))
            {
               this._upflagRight.visible = false;
               this._dowmArrowRight.visible = true;
            }
            else if(int(this._rightTxtBefore.text) < int(this._rightTxtAfter.text))
            {
               this._upflagRight.visible = true;
               this._dowmArrowRight.visible = false;
            }
         }
         else
         {
            this._upflagRight.visible = false;
            this._dowmArrowRight.visible = false;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         switch(this._type)
         {
            case 0:
               this._bloodLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.blood");
               PositionUtils.setPos(this._bloodLabel,"petsBag.view.infoFrame.labelPos");
               addChild(this._bloodLabel);
               break;
            case 1:
               this._attackLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.attack");
               PositionUtils.setPos(this._attackLabel,"petsBag.view.infoFrame.labelPos");
               addChild(this._attackLabel);
               break;
            case 2:
               this._defenceLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.defence");
               PositionUtils.setPos(this._defenceLabel,"petsBag.view.infoFrame.labelPos");
               addChild(this._defenceLabel);
               break;
            case 3:
               this._agilityLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.agility");
               PositionUtils.setPos(this._agilityLabel,"petsBag.view.infoFrame.labelPos");
               addChild(this._agilityLabel);
               break;
            case 4:
               this._luckLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.luck");
               PositionUtils.setPos(this._luckLabel,"petsBag.view.infoFrame.labelPos");
               addChild(this._luckLabel);
         }
         this._leftTxtBefore = ComponentFactory.Instance.creat("petsBag.petTransformFrame.propertyItem.leftBeforeValue");
         addChild(this._leftTxtBefore);
         this._leftTxtAfter = ComponentFactory.Instance.creat("petsBag.petTransformFrame.propertyItem.leftAfterValue");
         addChild(this._leftTxtAfter);
         this._rightTxtBefore = ComponentFactory.Instance.creat("petsBag.petTransformFrame.propertyItem.rightBeforeValue");
         addChild(this._rightTxtBefore);
         this._rightTxtAfter = ComponentFactory.Instance.creat("petsBag.petTransformFrame.propertyItem.rightAfterValue");
         addChild(this._rightTxtAfter);
         this._upflagLeft = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.increaseArrow");
         PositionUtils.setPos(this._upflagLeft,"asset.petsBag.petTransformFrame.upArrowPosLeft");
         this._upflagLeft.visible = false;
         addChild(this._upflagLeft);
         this._upflagRight = ComponentFactory.Instance.creat("asset.petsBag.petAdvanceFrame.increaseArrow");
         PositionUtils.setPos(this._upflagRight,"asset.petsBag.petTransformFrame.upArrowPosRight");
         this._upflagRight.visible = false;
         addChild(this._upflagRight);
         this._dowmArrowLeft = ComponentFactory.Instance.creatBitmap("asset.transform.down");
         PositionUtils.setPos(this._dowmArrowLeft,"asset.petsBag.petTransformFrame.downArrowPosLeft");
         this._dowmArrowLeft.visible = false;
         addChild(this._dowmArrowLeft);
         this._dowmArrowRight = ComponentFactory.Instance.creatBitmap("asset.transform.down");
         PositionUtils.setPos(this._dowmArrowRight,"asset.petsBag.petTransformFrame.downArrowPosRight");
         this._dowmArrowRight.visible = false;
         addChild(this._dowmArrowRight);
         _height = 22;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bloodLabel);
         this._bloodLabel = null;
         ObjectUtils.disposeObject(this._attackLabel);
         this._attackLabel = null;
         ObjectUtils.disposeObject(this._defenceLabel);
         this._defenceLabel = null;
         ObjectUtils.disposeObject(this._agilityLabel);
         this._agilityLabel = null;
         ObjectUtils.disposeObject(this._luckLabel);
         this._luckLabel = null;
         ObjectUtils.disposeObject(this._leftTxtBefore);
         this._leftTxtBefore = null;
         ObjectUtils.disposeObject(this._leftTxtAfter);
         this._leftTxtAfter = null;
         ObjectUtils.disposeObject(this._rightTxtBefore);
         this._rightTxtBefore = null;
         ObjectUtils.disposeObject(this._rightTxtAfter);
         this._rightTxtAfter = null;
         ObjectUtils.disposeObject(this._upflagLeft);
         this._upflagLeft = null;
         ObjectUtils.disposeObject(this._dowmArrowLeft);
         this._dowmArrowLeft = null;
         ObjectUtils.disposeObject(this._upflagRight);
         this._upflagRight = null;
         ObjectUtils.disposeObject(this._dowmArrowRight);
         this._dowmArrowRight = null;
         super.dispose();
      }
   }
}
