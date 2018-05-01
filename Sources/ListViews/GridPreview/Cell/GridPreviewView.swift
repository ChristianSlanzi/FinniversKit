//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol GridPreviewViewDataSource {
    func gridPreviewView(_ gridPreviewView: GridPreviewView, loadImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func gridPreviewView(_ gridPreviewView: GridPreviewView, cancelLoadingImageForModel model: GridPreviewListViewModel, imageWidth: CGFloat)
}

public class GridPreviewView: UIView {

    // MARK: - Internal properties

    private static let titleHeight: CGFloat = 20.0
    private static let titleTopMargin: CGFloat = 3.0
    private static let titleBottomMargin: CGFloat = 17.0
    private static let subtitleHeight: CGFloat = 17.0
    private static let subtitleTopMargin: CGFloat = 6.0
    private static let margin: CGFloat = 8.0
    private static let cornerRadius: CGFloat = 2.0
    private static let imageDescriptionHeight: CGFloat = 35.0
    private static let iconSize: CGFloat = 23.0

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = GridPreviewView.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .milk
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subTitleLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var imageDesciptionView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 1.0
        view.layer.cornerRadius = GridPreviewView.cornerRadius
        view.layer.masksToBounds = true

        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        }

        return view
    }()

    private lazy var imageTextLabel: Label = {
        let label = Label(style: .title4(.milk))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?

    /// A data source for the loading of the image
    public var dataSource: GridPreviewViewDataSource?

    /// Height in cell that is not image
    public static var nonImageHeight: CGFloat {
        return subtitleTopMargin + subtitleHeight + titleTopMargin + titleHeight + titleBottomMargin
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(imageView)
        addSubview(subTitleLabel)
        addSubview(titleLabel)
        addSubview(imageDesciptionView)

        imageDesciptionView.addSubview(iconImageView)
        imageDesciptionView.addSubview(imageTextLabel)

        backgroundColor = .white

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: GridPreviewView.subtitleTopMargin),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.heightAnchor.constraint(equalToConstant: GridPreviewView.subtitleHeight),

            titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: GridPreviewView.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: GridPreviewView.titleHeight),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -GridPreviewView.titleBottomMargin),

            iconImageView.leadingAnchor.constraint(equalTo: imageDesciptionView.leadingAnchor, constant: GridPreviewView.margin),
            iconImageView.heightAnchor.constraint(equalToConstant: GridPreviewView.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: GridPreviewView.iconSize),
            iconImageView.centerYAnchor.constraint(equalTo: imageDesciptionView.centerYAnchor),

            imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: GridPreviewView.margin),
            imageTextLabel.centerYAnchor.constraint(equalTo: imageDesciptionView.centerYAnchor),

            imageDesciptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageDesciptionView.trailingAnchor.constraint(equalTo: imageTextLabel.trailingAnchor, constant: GridPreviewView.margin),
            imageDesciptionView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageDesciptionView.heightAnchor.constraint(equalToConstant: GridPreviewView.imageDescriptionHeight),
            imageDesciptionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }

    // MARK: - Superclass Overrides

    public func prepareForReuse() {
        imageView.image = nil
        iconImageView.image = nil
        titleLabel.text = ""
        subTitleLabel.text = ""
        imageTextLabel.text = ""
        accessibilityLabel = ""

        if let model = model {
            dataSource?.gridPreviewView(self, cancelLoadingImageForModel: model, imageWidth: imageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    /// The model contains data used to populate the view.
    public var model: GridPreviewListViewModel? {
        didSet {
            if let model = model {
                iconImageView.image = model.iconImage?.withRenderingMode(.alwaysTemplate)
                titleLabel.text = model.title
                subTitleLabel.text = model.subTitle
                imageTextLabel.text = model.imageText
                accessibilityLabel = model.accessibilityLabel
            }
        }
    }

    // MARK: - Public

    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        if let model = model {
            loadImage(model: model)
        }
    }

    // MARK: - Private

    private func loadImage(model: GridPreviewListViewModel) {
        guard let dataSource = dataSource, let _ = model.imagePath else {
            loadingColor = .clear
            imageView.image = defaultImage
            return
        }

        imageView.backgroundColor = loadingColor

        dataSource.gridPreviewView(self, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.imageView.backgroundColor = .clear

            if let image = image {
                self?.imageView.image = image
            } else {
                self?.imageView.image = self?.defaultImage
            }
        }
    }

    private var defaultImage: UIImage? {
        return UIImage(frameworkImageNamed: "NoImage")
    }
}
