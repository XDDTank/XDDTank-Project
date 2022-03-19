// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoreBagBgWHPoint

package store
{
    public class StoreBagBgWHPoint 
    {

        public var sequencePoint:String;


        public function get pointArr():Array
        {
            return (this.sequencePoint.split(/,/g));
        }


    }
}//package store

