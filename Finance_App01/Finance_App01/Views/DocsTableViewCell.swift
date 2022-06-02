//
//  DocsTableViewCell.swift
//  Finance_App01
//
//  Created by a-robota on 6/1/22.
//

import UIKit

class DocsTableViewCell: UITableViewCell {

    private var docsCellResults : [docsResults] = []


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        docsCellResults
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  

    @IBOutlet weak var documentsLabel: UILabel!


    func configure(with : docsResults){
//        documentsLabel.text =
//            .append(FinanceDocs.self)
    }
    
}
