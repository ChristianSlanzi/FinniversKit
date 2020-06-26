//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

protocol VotingButtonViewDelegate: AnyObject {
    func votingButtonWasSelected(_ votingButton: VotingButtonView, identifier: String)
}

class VotingButtonView: UIView {

    // MARK: - Private properties

    private let viewModel: VotingButtonViewModel
    private weak var delegate: VotingButtonViewDelegate?
    private let enabledTintColor = UIColor.btnPrimary
    private let disabledTintColor = UIColor.textDisabled
    private lazy var titleLabel = Label(style: .captionStrong, withAutoLayout: true)
    private lazy var subtitleLabel = Label(style: .detail, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.addArrangedSubviews([iconImageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = .spacingXS
        return stackView
    }()

    // MARK: - Init

    init(viewModel: VotingButtonViewModel, delegate: VotingButtonViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = true
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        addSubview(stackView)
        stackView.fillInSuperview()

        iconImageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)
        titleLabel.text = viewModel.title

        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
            stackView.addArrangedSubview(subtitleLabel)
        }

        if viewModel.isEnabled || (!viewModel.isEnabled && viewModel.isSelected) {
            iconImageView.tintColor = enabledTintColor
        } else {
            iconImageView.tintColor = disabledTintColor
        }
    }

    // MARK: - Actions

    @objc private func handleTap() {
        guard viewModel.isEnabled else { return }
        delegate?.votingButtonWasSelected(self, identifier: viewModel.identifier)
    }
}
