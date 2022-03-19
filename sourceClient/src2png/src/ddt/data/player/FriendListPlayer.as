// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.FriendListPlayer

package ddt.data.player
{
    import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;

    public class FriendListPlayer extends PlayerInfo implements INotSameHeightListCellData 
    {

        public var Relation:int;
        public var type:int = 1;
        public var titleText:String = "";
        public var titleNumText:String = "";
        public var titleIsSelected:Boolean;
        public var titleType:int;
        public var BBSFriends:Boolean;
        public var UserName:String;
        public var Birthday:String;
        public var BirthdayDate:Date;
        public var canBeRemoved:Boolean = true;


        public function getCellHeight():Number
        {
            if (this.type == 0)
            {
                return (33);
            };
            if (this.type == 1)
            {
                return (33);
            };
            return (53);
        }


    }
}//package ddt.data.player

